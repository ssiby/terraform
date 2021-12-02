output "msk_zookeeper_connect_string" {
  value = module.msk.msk_zookeeper_connect_string
}

output "msk_bootstrap_brokers" {
  description = "Plaintext connection host:port pairs"
  value       = module.msk.msk_bootstrap_brokers
}

output "msk_bootstrap_brokers_tls" {
  description = "TLS connection host:port pairs"
  value       = module.msk.msk_bootstrap_brokers_tls
}

output "msk_sg_id" {
  value = module.msk.msk_sg_id
}

output "msk_vault_pki_secret_backend" {
  description = "Vault pki secret backend"
  value       = vault_mount.kafka_tls
}

