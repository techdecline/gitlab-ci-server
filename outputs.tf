output "gitlab_vm_name" {
  value = local.gitlab_vm_name
}

output "gitlab_vm_ip_address" {
  value = var.create_public_ip ? azurerm_public_ip.pip-gitlab[0].ip_address : azurerm_network_interface.nic-gitlab.private_ip_address
}

output "gitlab_dns_name" {
  value = var.create_public_ip ? azurerm_public_ip.pip-gitlab[0].fqdn : null
}

output "secrets" {
  value = {
    secret_name_password    = azurerm_key_vault_secret.secret-gitlab-pw.name
    secret_name_pat         = azurerm_key_vault_secret.secret-gitlab-pat.name
    secret_name_public_key  = azurerm_key_vault_secret.secret-gitlab-pub.name
    secret_name_private_key = azurerm_key_vault_secret.secret-gitlab-priv.name
  }
  
}