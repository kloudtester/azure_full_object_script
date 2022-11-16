resource "azurerm_resource_group" "qtrg" {
  name     = var.resource_group_name.name
  location = var.resource_group_name.location
}