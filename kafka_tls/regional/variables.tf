variable "aws_region" {
  description = "AWS region to host your platform"
}

variable "aws_profile" {
  description = "AWS profile used to manage resources on your platform"
}

variable "environment" {
  description = "Environment name"
}

variable "type" {
  description = "Normalized type"
  default     = "infra"
}

variable "project" {
  description = "Normalized project"
  default     = "kafka-tls"
}

variable "component" {
  description = "Normalized project"
  default     = "msk"
}

variable "kafka_server_properties" {
  description = "Broker parameter"
  default     = {}
}

variable "owner" {
  description = "Owner of the application (null by default)."
  default     = "sre"
}

variable "number_of_broker_nodes" {
  description = "(Required) The desired total number of broker nodes in the kafka cluster. It must be a multiple of the number of specified client subnets"
  default     = 3
}

variable "instance_type" {
  description = "(Required) Specify the instance type to use for the kafka brokers"
  default     = "kafka.t3.small"
}

variable "kafka_version" {
  description = "(Required) Specify the desired Kafka software version"
}

variable "config_name_suffix" {
  description = "Suffix to append to the cluster configuration name"
}

variable "ebs_volume_size" {
  description = "(Required) The size in GiB of the EBS volume for the data drive on each broker node"
}

variable "subnets_allowed" {
  description = "CIDRs allowed to access MSK cluster"
  default     = ""
}

variable "sg_appli_allowed" {
  description = "Application SG allowed to access the MSK cluster"
  default     = ""
}

variable "sg_data_allowed" {
  description = "Data SG allowed to access the MSK cluster"
  default     = ""
}

variable "intermediate_ca" {
  description = "Map containing intermediate_ca_secret_name & env_target"
  type        = map(string)
  default = {
    "secret_name" : "",
    "env_target" : ""
  }
}

variable "subca_list" {
  description = "SubordinateCA list"
  default     = ""
}

