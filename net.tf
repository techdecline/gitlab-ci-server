resource "azurerm_public_ip" "pip-gitlab" {
  count               = var.create_public_ip ? 1 : 0
  name                = "pip-${local.gitlab_vm_name}"
  resource_group_name = data.azurerm_resource_group.rg-gitlab.name
  location            = data.azurerm_resource_group.rg-gitlab.location
  allocation_method   = "Static"
  sku                 = "standard"
  domain_name_label   = length(var.dns_label) > 0 ? var.dns_label : local.gitlab_vm_name
}

resource "azurerm_network_interface" "nic-gitlab" {
  name                = "nic-${local.gitlab_vm_name}"
  resource_group_name = data.azurerm_resource_group.rg-gitlab.name
  location            = data.azurerm_resource_group.rg-gitlab.location

  ip_configuration {
    name                          = "ipconfig0"
    subnet_id                     = var.vm_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.create_public_ip ? azurerm_public_ip.pip-gitlab[0].id : null
  }
}