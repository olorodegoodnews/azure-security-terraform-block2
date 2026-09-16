data "azurerm_client_config" "current" {}

resource "random_string" "keyvault_suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_key_vault" "block2" {
  name                = "kv-block2-${random_string.keyvault_suffix.result}"
  location            = azurerm_resource_group.block2.location
  resource_group_name = azurerm_resource_group.block2.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  enable_rbac_authorization = true

  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  tags = {
    environment = "lab"
    managed_by  = "terraform"
    project     = "caleb-block2"
  }
}

resource "azurerm_role_assignment" "current_user_keyvault" {
  scope                = azurerm_key_vault.block2.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = var.keyvault_secrets_officer_principal_id
}