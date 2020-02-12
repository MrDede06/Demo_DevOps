
resource "azurerm_virtual_machine" "local_VM1" {
  name                  = "VM1"
  location              = var.location
  resource_group_name   = azurerm_resource_group.local_resource_group.name
  network_interface_ids = [azurerm_network_interface.local_nic.id]
  vm_size               = "Standard_B1ls"

  # this is a demo instance, so we can delete all data on termination
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  identity {
    type = "SystemAssigned"
  }


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


resource "azurerm_dns_zone" "example_zone" {
  name                = "dededevops.com"
  resource_group_name = azurerm_resource_group.local_resource_group.name
}

resource "azurerm_dns_a_record" "example" {
  name                = "dededevops.com"
  zone_name           = azurerm_dns_zone.example_zone.name
  resource_group_name = azurerm_resource_group.local_resource_group.name
  ttl                 = 300
  records  = [azurerm_public_ip.local_public_ip2.ip_address]
}




resource "azurerm_lb" "example_lb" {
  name                = "TestLoadBalancer"
  location            = var.location
  resource_group_name = azurerm_resource_group.local_resource_group.name

  frontend_ip_configuration {
    name                 = "LoadBalancerFrontEnd"
    public_ip_address_id = azurerm_public_ip.local_public_ip2.id
  }
}

resource "azurerm_lb_backend_address_pool" "example_backend" {
  resource_group_name = azurerm_resource_group.local_resource_group.name
  loadbalancer_id     = "${azurerm_lb.example_lb.id}"
  name                = "BackEndAddressPool"
}
/*
** if you want make port mapping 
resource "azurerm_lb_nat_rule" "example_nat" {
  resource_group_name            = azurerm_resource_group.local_resource_group.name
  loadbalancer_id                = "${azurerm_lb.exampl_lb.id}"
  name                           = "lb-nat-rule"
  protocol                       = "Tcp"
  frontend_port                  = 3389
  backend_port                   = 3389
  frontend_ip_configuration_name = "PublicIPAddress"
}
*/

resource "azurerm_lb_probe" "example" {
  resource_group_name = azurerm_resource_group.local_resource_group.name
  loadbalancer_id     = "${azurerm_lb.example_lb.id}"
  name                = "tcp_probe"
  protocol            = "tcp"
  port                = 80
}

resource "azurerm_lb_rule" "example" {
  resource_group_name = azurerm_resource_group.local_resource_group.name
  loadbalancer_id     = "${azurerm_lb.example_lb.id}"
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "LoadBalancerFrontEnd"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.example_backend.id
  probe_id                       = azurerm_lb_probe.example.id
}

resource "azurerm_lb_rule" "example2" {
  resource_group_name = azurerm_resource_group.local_resource_group.name
  loadbalancer_id     = "${azurerm_lb.example_lb.id}"
  name                           = "LBRuleSSH"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = "LoadBalancerFrontEnd"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.example_backend.id
}