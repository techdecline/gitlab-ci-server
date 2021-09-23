resource "azurerm_linux_virtual_machine" "vm-gitlab" {
  name                = local.gitlab_vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = "gitlabadmin"
  #custom_data         = base64encode(data.template_file.init-gitlab.rendered)
  network_interface_ids = [
    azurerm_network_interface.nic-gitlab.id,
  ]
  admin_ssh_key {
    username   = "gitlabadmin"
    public_key = tls_private_key.ssh.public_key_openssh
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
  source_image_reference {
    publisher = "gitlabinc1586447921813"
    offer     = "gitlabee"
    sku       = "default"
    version   = "latest"
  }
  plan {
    name      = "default"
    publisher = "gitlabinc1586447921813"
    product   = "gitlabee"
  }

  depends_on = [
    azurerm_marketplace_agreement.eula-gitlab
  ]
}

resource "azurerm_virtual_machine_extension" "vmext" {
  name                 = "${local.gitlab_vm_name}-vmext1"
  depends_on           = [azurerm_linux_virtual_machine.vm-gitlab]
  virtual_machine_id   = azurerm_linux_virtual_machine.vm-gitlab.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"
  provisioner "local-exec" {
    command = "sleep 120"
  }
  protected_settings = <<SETTINGS
    {
      "script": "${base64encode(data.template_file.init-gitlab.rendered)}"
    }
SETTINGS
  lifecycle {
    ignore_changes = [protected_settings]
  }
}