resource "random_string" "storage_suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_storage_account" "block2" {
  #checkov:skip=CKV_AZURE_33:Azure Queue Storage is not used by this project, so Queue service logging is not enabled.
  #checkov:skip=CKV_AZURE_206:LRS is intentionally used for this non-production student lab to conserve Azure credits.
  #checkov:skip=CKV2_AZURE_1:Customer-managed keys are not required because this lab does not store production or critical data.

  name                     = "stblock2${random_string.storage_suffix.result}"
  resource_group_name      = azurerm_resource_group.block2.name
  location                 = azurerm_resource_group.block2.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = false
  shared_access_key_enabled       = false

  blob_properties {
    delete_retention_policy {
      days = 7
    }

    container_delete_retention_policy {
      days = 7
    }
  }

  tags = {
    environment = "lab"
    managed_by  = "terraform"
    project     = "caleb-block2"
  }
}

resource "azurerm_storage_account_network_rules" "block2" {
  storage_account_id = azurerm_storage_account.block2.id

  default_action = "Deny"
  bypass         = ["AzureServices"]
}

resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.block2.name

  tags = {
    environment = "lab"
    managed_by  = "terraform"
    project     = "caleb-block2"
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob" {
  name                  = "link-block2-blob-private-dns"
  resource_group_name   = azurerm_resource_group.block2.name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = azurerm_virtual_network.block2.id
  registration_enabled  = false

  tags = {
    environment = "lab"
    managed_by  = "terraform"
    project     = "caleb-block2"
  }
}

resource "azurerm_private_endpoint" "storage_blob" {
  name                = "pe-block2-storage-blob"
  location            = azurerm_resource_group.block2.location
  resource_group_name = azurerm_resource_group.block2.name
  subnet_id           = azurerm_subnet.private_endpoints.id

  private_service_connection {
    name                           = "psc-block2-storage-blob"
    private_connection_resource_id = azurerm_storage_account.block2.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "storage-blob-private-dns"
    private_dns_zone_ids = [azurerm_private_dns_zone.blob.id]
  }

  tags = {
    environment = "lab"
    managed_by  = "terraform"
    project     = "caleb-block2"
  }
}