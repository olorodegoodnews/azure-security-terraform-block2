resource "azurerm_log_analytics_workspace" "block2" {
  name                = "law-block2-security"
  location            = azurerm_resource_group.block2.location
  resource_group_name = azurerm_resource_group.block2.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    environment = "lab"
    managed_by  = "terraform"
    project     = "caleb-block2"
  }
}

resource "azurerm_policy_definition" "deploy_keyvault_diagnostics" {
  name         = "deploy-keyvault-diagnostics"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Deploy Key Vault Diagnostic Settings"

  description = "Deploys Key Vault diagnostic settings to the Block 2 Log Analytics workspace when they do not already exist."

  parameters = jsonencode({
    logAnalytics = {
      type = "String"

      metadata = {
        displayName = "Log Analytics workspace"
        description = "Resource ID of the Log Analytics workspace used for Key Vault diagnostic logs."
      }
    }
  })

  policy_rule = jsonencode({
    if = {
      field  = "type"
      equals = "Microsoft.KeyVault/vaults"
    }

    then = {
      effect = "DeployIfNotExists"

      details = {
        type            = "Microsoft.Insights/diagnosticSettings"
        name            = "setbypolicy-kv-logs"
        evaluationDelay = "AfterProvisioning"

        existenceCondition = {
          allOf = [
            {
              field  = "Microsoft.Insights/diagnosticSettings/workspaceId"
              equals = "[parameters('logAnalytics')]"
            },
            {
              count = {
                field = "Microsoft.Insights/diagnosticSettings/logs[*]"

                where = {
                  allOf = [
                    {
                      field  = "Microsoft.Insights/diagnosticSettings/logs[*].enabled"
                      equals = true
                    },
                    {
                      field  = "Microsoft.Insights/diagnosticSettings/logs[*].category"
                      equals = "AuditEvent"
                    }
                  ]
                }
              }

              greaterOrEquals = 1
            }
          ]
        }

        roleDefinitionIds = [
          "/providers/Microsoft.Authorization/roleDefinitions/749f88d5-cbae-40b8-bcfc-e573ddc772fa",
          "/providers/Microsoft.Authorization/roleDefinitions/92aaf0da-9dab-42b6-94a3-d43ce8d16293"
        ]

        deployment = {
          properties = {
            mode = "incremental"

            template = {
              "$schema"      = "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#"
              contentVersion = "1.0.0.0"

              parameters = {
                resourceName = {
                  type = "string"
                }

                location = {
                  type = "string"
                }

                logAnalytics = {
                  type = "string"
                }
              }

              resources = [
                {
                  type       = "Microsoft.KeyVault/vaults/providers/diagnosticSettings"
                  apiVersion = "2017-05-01-preview"

                  name = "[concat(parameters('resourceName'), '/Microsoft.Insights/setbypolicy-kv-logs')]"

                  location = "[parameters('location')]"

                  properties = {
                    workspaceId = "[parameters('logAnalytics')]"

                    logs = [
                      {
                        category = "AuditEvent"
                        enabled  = true
                      },
                      {
                        category = "AzurePolicyEvaluationDetails"
                        enabled  = true
                      }
                    ]
                  }
                }
              ]
            }

            parameters = {
              resourceName = {
                value = "[field('name')]"
              }

              location = {
                value = "[field('location')]"
              }

              logAnalytics = {
                value = "[parameters('logAnalytics')]"
              }
            }
          }
        }
      }
    }
  })
}

resource "azurerm_resource_group_policy_assignment" "deploy_keyvault_diagnostics" {
  name                 = "deploy-kv-diagnostics"
  resource_group_id    = azurerm_resource_group.block2.id
  policy_definition_id = azurerm_policy_definition.deploy_keyvault_diagnostics.id

  display_name = "Deploy Key Vault Diagnostic Settings"
  description  = "Automatically deploys Key Vault diagnostic settings to Log Analytics."

  location = azurerm_resource_group.block2.location

  identity {
    type = "SystemAssigned"
  }

  parameters = jsonencode({
    logAnalytics = {
      value = azurerm_log_analytics_workspace.block2.id
    }
  })
}

resource "azurerm_role_assignment" "policy_monitoring_contributor" {
  scope                = azurerm_resource_group.block2.id
  role_definition_name = "Monitoring Contributor"
  principal_id         = azurerm_resource_group_policy_assignment.deploy_keyvault_diagnostics.identity[0].principal_id
}

resource "azurerm_role_assignment" "policy_log_analytics_contributor" {
  scope                = azurerm_resource_group.block2.id
  role_definition_name = "Log Analytics Contributor"
  principal_id         = azurerm_resource_group_policy_assignment.deploy_keyvault_diagnostics.identity[0].principal_id
}

resource "azurerm_resource_group_policy_remediation" "deploy_keyvault_diagnostics" {
  name                 = "remediate-kv-diagnostics"
  resource_group_id    = azurerm_resource_group.block2.id
  policy_assignment_id = azurerm_resource_group_policy_assignment.deploy_keyvault_diagnostics.id

  resource_discovery_mode = "ReEvaluateCompliance"

  depends_on = [
    azurerm_role_assignment.policy_monitoring_contributor,
    azurerm_role_assignment.policy_log_analytics_contributor
  ]
}