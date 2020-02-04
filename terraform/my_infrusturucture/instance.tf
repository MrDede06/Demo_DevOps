resource "azurerm_virtual_machine" "local_VM1" {
  name                  = "VM1"
  location              = var.location
  resource_group_name   = azurerm_resource_group.local_resource_group.name
  network_interface_ids = [azurerm_network_interface.local_nic.id]
  vm_size               = "Standard_B1ls"

  # this is a demo instance, so we can delete all data on termination
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "VM1"
    admin_username = "dede"
    #admin_password = "..."
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("/home/dede/.ssh/authorized_keys")
      path     = "/home/dede/.ssh/authorized_keys"
    }
  }
}