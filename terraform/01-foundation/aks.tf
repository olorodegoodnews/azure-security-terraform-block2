resource "azurerm_user_assigned_identity" "aks" {
  name                = "id-block2-aks"
  location            = azurerm_resource_group.block2.location
  resource_group_name = azurerm_resource_group.block2.name

  tags = {
    environment = "lab"
    managed_by  = "terraform"
    project     = "caleb-block2"
  }
}

resource "azurerm_role_assignment" "aks_network_contributor" {
  scope                = azurerm_subnet.aks.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

resource "azurerm_kubernetes_cluster" "block2" {
  name                = "aks-block2-security-lab"
  location            = azurerm_resource_group.block2.location
  resource_group_name = azurerm_resource_group.block2.name
  dns_prefix          = "aks-block2-security"
  node_resource_group = "rg-block2-aks-nodes"

  sku_tier = "Free"

  role_based_access_control_enabled = true

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  default_node_pool {
    name           = "system"
    node_count     = 1
    vm_size        = "Standard_B2s_v2"
    vnet_subnet_id = azurerm_subnet.aks.id

    os_disk_size_gb = 30

    tags = {
      environment = "lab"
      managed_by  = "terraform"
      project     = "caleb-block2"
    }
  }

  identity {
    type = "UserAssigned"

    identity_ids = [
      azurerm_user_assigned_identity.aks.id
    ]
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"

    network_data_plane = "cilium"
    network_policy     = "cilium"

    pod_cidr       = "10.244.0.0/16"
    service_cidr   = "10.0.0.0/16"
    dns_service_ip = "10.0.0.10"

    load_balancer_sku = "standard"
  }

  tags = {
    environment = "lab"
    managed_by  = "terraform"
    project     = "caleb-block2"
  }

  depends_on = [
    azurerm_role_assignment.aks_network_contributor
  ]
}