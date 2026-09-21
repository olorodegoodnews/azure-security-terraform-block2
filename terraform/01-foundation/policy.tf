resource "azurerm_policy_definition" "deny_storage_public_network" {
  name         = "deny-storage-public-network"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Deny Storage Accounts with Public Network Access"

  description = "Denies Azure Storage Accounts that have public network access enabled."

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field  = "type"
          equals = "Microsoft.Storage/storageAccounts"
        },
        {
          field     = "Microsoft.Storage/storageAccounts/publicNetworkAccess"
          notEquals = "Disabled"
        }
      ]
    }

    then = {
      effect = "Deny"
    }
  })
}

resource "azurerm_resource_group_policy_assignment" "deny_storage_public_network" {
  name                 = "deny-storage-public-network"
  resource_group_id    = azurerm_resource_group.block2.id
  policy_definition_id = azurerm_policy_definition.deny_storage_public_network.id

  display_name = "Deny Storage Public Network Access"
  description  = "Prevents Storage Accounts in the Block 2 resource group from enabling public network access."
}