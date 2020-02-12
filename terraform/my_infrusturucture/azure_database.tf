resource "azurerm_postgresql_server" "demo" {
  name                = "mypostgresdb12r43dsffwe"
  location            = var.location
  resource_group_name = azurerm_resource_group.local_resource_group.name

  sku {
    name     = "GP_Gen5_2"
    capacity = 2
    tier     = "GeneralPurpose"
    family   = "Gen5"
  }

  storage_profile {
    storage_mb            = 5120
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
  }

  administrator_login          = "postgres"
  administrator_login_password = "Leanback06"
  version                      = "9.5"
  ssl_enforcement              = "Disabled"
}

resource "azurerm_postgresql_database" "training" {
  name                = "demodb"
  resource_group_name = azurerm_resource_group.local_resource_group.name
  server_name         = azurerm_postgresql_server.demo.name
  charset             = "utf8"
  collation           = "English_United States.1252"
}

resource "azurerm_postgresql_virtual_network_rule" "demo-database-subnet-vnet-rule" {
  name                = "mypostgressql-vnet-rule"
  resource_group_name = azurerm_resource_group.local_resource_group.name
  server_name         = azurerm_postgresql_server.demo.name
  subnet_id           = azurerm_subnet.local_subnet_2.id
}

resource "azurerm_postgresql_virtual_network_rule" "demo-subnet-vnet-rule" {
  name                = "mypostgressql-demo-subnet-vnet-rule"
  resource_group_name = azurerm_resource_group.local_resource_group.name
  server_name         = azurerm_postgresql_server.demo.name
  subnet_id           = azurerm_subnet.local_subnet_1.id
}

resource "azurerm_postgresql_firewall_rule" "demo-allow-instance" {
  name                = "postfresfirewall"
  resource_group_name = azurerm_resource_group.local_resource_group.name
  server_name         = azurerm_postgresql_server.demo.name
  start_ip_address    = azurerm_network_interface.local_nic.private_ip_address
  end_ip_address      = azurerm_network_interface.local_nic.private_ip_address
}
