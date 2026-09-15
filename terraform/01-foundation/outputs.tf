output "resource_group_name" {
  description = "Name of the Block 2 resource group"
  value       = azurerm_resource_group.block2.name
}

output "resource_group_location" {
  description = "Location of the Block 2 resource group"
  value       = azurerm_resource_group.block2.location
}

output "virtual_network_name" {
  description = "Name of the Block 2 virtual network"
  value       = azurerm_virtual_network.block2.name
}

output "app_subnet_name" {
  description = "Name of the application subnet"
  value       = azurerm_subnet.app.name
}

output "aks_subnet_name" {
  description = "Name of the AKS subnet"
  value       = azurerm_subnet.aks.name
}

output "app_network_security_group_name" {
  description = "Name of the application Network Security Group"
  value       = azurerm_network_security_group.app.name
}