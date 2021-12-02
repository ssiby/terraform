##
#
# Providers
#

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

provider "aws" {
  alias   = "support"
  region  = var.aws_region
  profile = "manomano-support"
}

provider "vault" {
  address = data.terraform_remote_state.remote_state.outputs.vault_endpoint
}

##
#
# Remote states
#

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket  = "mm-terraform-remote-states-${var.aws_region}"
    key     = "${var.environment}/infra/vpc.tfstate"
    region  = var.aws_region
    profile = "manomano-support"
  }
}

data "terraform_remote_state" "global_sg" {
  backend = "s3"

  config = {
    bucket  = "mm-terraform-remote-states-${var.aws_region}"
    key     = "${var.environment}/infra/global_sg.tfstate"
    region  = var.aws_region
    profile = "manomano-support"
  }
}

data "terraform_remote_state" "remote_state" {
  backend = "s3"

  config = {
    bucket  = "mm-terraform-remote-states-${var.aws_region}"
    key     = "${var.environment}/infra/remote_state.tfstate"
    region  = var.aws_region
    profile = "manomano-support"
  }
}

data "terraform_remote_state" "datadog" {
  backend = "s3"

  config = {
    bucket  = "mm-terraform-remote-states-${var.aws_region}"
    key     = "${var.environment}/infra/datadog.tfstate"
    region  = var.aws_region
    profile = "manomano-support"
  }
}

data "terraform_remote_state" "msk_subordinate_ca" {
  backend = "s3"

  config = {
    bucket  = "mm-terraform-remote-states-${var.aws_region}"
    key     = "${var.environment}/infra/kafka_pki_subordinate_ca.tfstate"
    region  = var.aws_region
    profile = "manomano-support"
  }
}

##
#
# Naming
#

module "msk_names" {
  source      = "git::ssh://git@github.com:ssiby/terraform-module/naming.git?ref=master"
  region      = var.aws_region
  environment = var.environment
  type        = var.type
  project     = var.project
  component   = var.component
  owner       = var.owner
}

##
#
# Cluster
#
module "msk" {
  source = "git::ssh://git@github.com:ssiby/terraform-module/msk_cluster.git?ref=v2.0.3"
  names  = module.msk_names.names

  kafka_version           = var.kafka_version
  kafka_server_properties = var.kafka_server_properties
  instance_type           = var.instance_type
  ebs_volume_size         = var.ebs_volume_size
  vpc_id                  = data.terraform_remote_state.vpc.outputs.infra_vpc_id
  client_subnets          = data.terraform_remote_state.vpc.outputs.infra_subnet_data_ids
  number_of_broker_nodes  = var.number_of_broker_nodes

  sg_data_allowed = data.terraform_remote_state.global_sg.outputs.data_mgmt
  subnets_allowed = "${data.terraform_remote_state.vpc.outputs.infra_subnet_app_cidr_block},${data.terraform_remote_state.remote_state.outputs.support_app_cidr},${data.terraform_remote_state.global_sg.outputs.nodata},${data.terraform_remote_state.global_sg.outputs.office}"

  config_name_suffix     = var.config_name_suffix
  msk_subordinate_ca_arn = data.terraform_remote_state.msk_subordinate_ca.outputs.msk_subordinate_ca_arn["RSA"]
}

module "tools_in" {
  source = "git::ssh://git@github.com:ssiby/terraform-module/security_sg_rule_cidr?ref=v2.0.0"

  type              = "ingress"
  from_port         = "8081"
  to_port           = "8085"
  protocol          = "tcp"
  cidr_blocks       = "${data.terraform_remote_state.vpc.outputs.infra_subnet_app_cidr_block},${data.terraform_remote_state.remote_state.outputs.support_app_cidr},${data.terraform_remote_state.global_sg.outputs.nodata},${data.terraform_remote_state.global_sg.outputs.office}"
  description       = "Allow Kafka tools access to MSK cluster"
  security_group_id = module.msk.msk_sg_id
}
