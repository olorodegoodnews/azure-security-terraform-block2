resource "random_string" "storage_suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_storage_account" "block2" {
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

  tags = {
    environment = "lab"
    managed_by  = "terraform"
    project     = "caleb-block2"
  }
}

resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.block2.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob" {
  name                  = "link-block2-blob-private-dns"
  resource_group_name   = azurerm_resource_group.block2.name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = azurerm_virtual_network.block2.id
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