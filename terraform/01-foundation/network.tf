resource "azurerm_virtual_network" "block2" {
  name                = "vnet-block2-security-lab"
  address_space       = ["10.20.0.0/16"]
  location            = azurerm_resource_group.block2.location
  resource_group_name = azurerm_resource_group.block2.name

  tags = {
    environment = "lab"
    managed_by  = "terraform"
    project     = "caleb-block2"
  }
}

resource "azurerm_subnet" "app" {
  name                 = "snet-app"
  resource_group_name  = azurerm_resource_group.block2.name
  virtual_network_name = azurerm_virtual_network.block2.name
  address_prefixes     = ["10.20.1.0/24"]
}

resource "azurerm_subnet" "aks" {
  name                 = "snet-aks"
  resource_group_name  = azurerm_resource_group.block2.name
  virtual_network_name = azurerm_virtual_network.block2.name
  address_prefixes     = ["10.20.2.0/24"]
}

resource "azurerm_network_security_group" "app" {
  name                = "nsg-block2-app"
  location            = azurerm_resource_group.block2.location
  resource_group_name = azurerm_resource_group.block2.name

  security_rule {
    name                       = "Allow-HTTPS-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "lab"
    managed_by  = "terraform"
    project     = "caleb-block2"
  }
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}

resource "azurerm_subnet" "private_endpoints" {
  name                 = "snet-private-endpoints"
  resource_group_name  = azurerm_resource_group.block2.name
  virtual_network_name = azurerm_virtual_network.block2.name
  address_prefixes     = ["10.20.3.0/24"]
}