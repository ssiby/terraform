#
# Fetch
#
data "aws_secretsmanager_secret" "intermediate_ca" {
  name     = var.intermediate_ca.secret_name
  provider = aws.support
}

data "aws_secretsmanager_secret_version" "intermediate_ca" {
  secret_id = data.aws_secretsmanager_secret.intermediate_ca.name
  provider  = aws.support
}

#
# Locals
#
locals {
  intermediate_ca_cert = base64decode(jsondecode(data.aws_secretsmanager_secret_version.intermediate_ca.secret_string)["intermediate_ca_cert"])
  intermediate_ca_key  = base64decode(jsondecode(data.aws_secretsmanager_secret_version.intermediate_ca.secret_string)["intermediate_ca_key"])
}

#
# Ressource
#
resource "vault_mount" "kafka_tls" {
  path        = "${var.environment}-kafka-tls"
  type        = "pki"
  description = "MSK's ${upper(var.environment)} Vault PKI Secret Backend"

  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 86400
}

resource "vault_pki_secret_backend_config_urls" "kafka_tls" {
  backend              = vault_mount.kafka_tls.path
  issuing_certificates = ["https://vault.manomano.tech/v1/${var.intermediate_ca.env_target}-kafka-tls/ca"]
}

resource "vault_pki_secret_backend_config_ca" "kafka_tls" {
  depends_on = [vault_mount.kafka_tls]

  backend    = vault_mount.kafka_tls.path
  pem_bundle = <<EOT
${chomp(local.intermediate_ca_key)}
${chomp(local.intermediate_ca_cert)}
EOT
}

