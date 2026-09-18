resource "azurerm_user_assigned_identity" "workload" {
  name                = "id-block2-workload"
  location            = azurerm_resource_group.block2.location
  resource_group_name = azurerm_resource_group.block2.name

  tags = {
    environment = "lab"
    managed_by  = "terraform"
    project     = "caleb-block2"
  }
}

resource "azurerm_federated_identity_credential" "workload" {
  name                = "fic-block2-workload"
  resource_group_name = azurerm_resource_group.block2.name
  parent_id           = azurerm_user_assigned_identity.workload.id

  audience = [
    "api://AzureADTokenExchange"
  ]

  issuer = azurerm_kubernetes_cluster.block2.oidc_issuer_url

  subject = "system:serviceaccount:block2-app:block2-workload-sa"
}

output "workload_identity_client_id" {
  description = "Client ID used by the AKS workload service account"
  value       = azurerm_user_assigned_identity.workload.client_id
}

resource "azurerm_role_assignment" "workload_keyvault_secrets_user" {
  scope                = azurerm_key_vault.block2.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.workload.principal_id
}