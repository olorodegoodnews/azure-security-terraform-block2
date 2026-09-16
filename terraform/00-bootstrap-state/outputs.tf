output "tfstate_resource_group_name" {
  description = "Resource group containing the Terraform remote state backend"
  value       = azurerm_resource_group.tfstate.name
}

output "tfstate_storage_account_name" {
  description = "Storage Account used for Terraform remote state"
  value       = azurerm_storage_account.tfstate.name
}

output "tfstate_container_name" {
  description = "Blob container used for Terraform remote state"
  value       = azurerm_storage_container.tfstate.name
}