provider "azurerm" {
  version = "=1.30.0"
}

resource "azurerm_resource_group" "local_resource_group" {
  name     = "demoDevOps_RG"
  location = var.location
}
