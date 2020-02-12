resource "azurerm_virtual_network" "local_virtual_network" {
    name = "VPC_TF"
    location = var.location
    resource_group_name = azurerm_resource_group.local_resource_group.name
    address_space = ["10.0.0.0/25"]

#    dynamic "subnet" {
#        for_each = [for s in var.subnet_config: {
#          name = s.name
#          prefix = s.ip_address
#        }]
#    content {
#      name           = subnet.value.name
#      address_prefix = subnet.value.prefix
#    }    
#    }
}

resource "azurerm_subnet" "local_subnet_1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.local_resource_group.name
  virtual_network_name = azurerm_virtual_network.local_virtual_network.name
  address_prefix       = "10.0.0.0/28"
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_subnet" "local_subnet_2" {
  name                 = "subnet2"
  resource_group_name  = azurerm_resource_group.local_resource_group.name
  virtual_network_name = azurerm_virtual_network.local_virtual_network.name
  address_prefix       = "10.0.0.16/28"
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_network_interface" "local_nic" {
  name                      = "nic1"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.local_resource_group.name
  network_security_group_id = azurerm_network_security_group.local_nsg.id

  ip_configuration {
    name                          = "instance1"
    subnet_id                     = azurerm_subnet.local_subnet_1.id
    private_ip_address_allocation = "Dynamic"
#    public_ip_address_id          = azurerm_public_ip.local_public_ip.id
    load_balancer_backend_address_pools_ids =  [azurerm_lb_backend_address_pool.example_backend.id]
  }
}
/*
resource "azurerm_public_ip" "local_public_ip" {
    name                         = "instance1-public-ip"
    location                     = var.location
    resource_group_name          = azurerm_resource_group.local_resource_group.name
    allocation_method            = "Dynamic"
}
*/
resource "azurerm_public_ip" "local_public_ip2" {
    name                         = "instance1-public-ip2"
    location                     = var.location
    resource_group_name          = azurerm_resource_group.local_resource_group.name
    allocation_method            = "Dynamic"
}


resource "azurerm_network_security_group" "local_nsg" {
    name                = "allow-ssh-web"
    location            = var.location
    resource_group_name = azurerm_resource_group.local_resource_group.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = var.ssh-source-address
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "HTTP"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = var.ssh-source-address
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "HTTPS"
        priority                   = 1003
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "8080"
        source_address_prefix      = var.ssh-source-address
        destination_address_prefix = "*"
    }
}


