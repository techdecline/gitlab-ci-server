resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}


resource "random_password" "gitlab-password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "random_password" "gitlab-pat" {
  length           = 20
  special          = false
}

resource "azurerm_key_vault_secret" "secret-gitlab-priv" {
  name         = "${local.gitlab_vm_name}-priv"
  value        = tls_private_key.ssh.private_key_pem
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "secret-gitlab-pub" {
  name         = "${local.gitlab_vm_name}-pub"
  value        = tls_private_key.ssh.public_key_openssh
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "secret-gitlab-pw" {
  name         = "${local.gitlab_vm_name}-pass"
  value        = random_password.gitlab-password.result
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "secret-gitlab-pat" {
  name         = "${local.gitlab_vm_name}-pat"
  value        = random_password.gitlab-pat.result
  key_vault_id = var.key_vault_id
}