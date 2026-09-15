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

output "key_vault_name" {
  description = "Name of the Block 2 Azure Key Vault"
  value       = azurerm_key_vault.block2.name
}

output "key_vault_uri" {
  description = "URI of the Block 2 Azure Key Vault"
  value       = azurerm_key_vault.block2.vault_uri
}

output "storage_account_name" {
  description = "Name of the Block 2 Storage Account"
  value       = azurerm_storage_account.block2.name
}

output "private_endpoint_name" {
  description = "Name of the Storage Account Private Endpoint"
  value       = azurerm_private_endpoint.storage_blob.name
}

output "private_endpoint_subnet_name" {
  description = "Name of the Private Endpoint subnet"
  value       = azurerm_subnet.private_endpoints.name
}