terraform {
  required_providers {
    azurerm = {
      version = ">= 2.75.0"
    }
  }
}

locals {
  dns_name = var.create_public_ip ? azurerm_public_ip.pip-gitlab[0].fqdn : azurerm_network_interface.nic-gitlab.private_ip_address
  gitlab_vm_name = substr("${var.gitlab_vm_name}${random_string.guid.result}",0,15)
}

resource "random_string" "guid" {
  length           = 16
  special          = false
  upper            = false
}

data "azurerm_resource_group" "rg-gitlab" {
  name = var.resource_group_name
}

data "template_file" "init-gitlab" {
  template = file("${path.module}/scripts/init.sh")
  vars = {
    EXTERNAL_URL          = "https://${local.dns_name}"
    PASSWORD              = random_password.gitlab-password.result
    PERSONAL_ACCESS_TOKEN = random_password.gitlab-pat.result
  }
}