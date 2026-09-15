output "resource_group_name" {
  description = "Name of the Block 2 resource group"
  value       = azurerm_resource_group.block2.name
}

output "resource_group_location" {
  description = "Location of the Block 2 resource group"
  value       = azurerm_resource_group.block2.location
}