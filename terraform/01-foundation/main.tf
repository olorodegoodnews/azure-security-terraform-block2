resource "azurerm_resource_group" "block2" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = "lab"
    managed_by  = "terraform"
    project     = "Build-block2"
  }
}