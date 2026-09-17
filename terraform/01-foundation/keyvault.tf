data "azurerm_client_config" "current" {}

resource "random_string" "keyvault_suffix" {
  length  = 6
  upper   = false
  special = false
}

#trivy:ignore:AVD-AZU-0013
resource "azurerm_key_vault" "block2" {
  #checkov:skip=CKV_AZURE_189:Public network access retained temporarily because this lab does not have a private runner or VPN path to the Key Vault.
  #checkov:skip=CKV_AZURE_109:Key Vault firewall restrictions are deferred until a private access path is available.
  #checkov:skip=CKV_AZURE_110:Purge protection is intentionally disabled in this disposable student lab so the environment can be fully destroyed.
  #checkov:skip=CKV_AZURE_42:Recoverability requirement is accepted because purge protection is intentionally disabled for lab teardown.
  #checkov:skip=CKV2_AZURE_32:A Key Vault private endpoint is outside the current Block 2 requirement; private connectivity is implemented for Azure Storage.

  name                = "kv-block2-${random_string.keyvault_suffix.result}"
  location            = azurerm_resource_group.block2.location
  resource_group_name = azurerm_resource_group.block2.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  rbac_authorization_enabled = true

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