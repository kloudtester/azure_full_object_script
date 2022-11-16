resource "azurerm_virtual_network" "qtvnet" {
  name                = var.vnet.name
  location            = var.resource_group_name.location
  address_space       = var.vnet.address_space
  resource_group_name = var.resource_group_name.name
  depends_on = [
    azurerm_resource_group.qtrg
  ]
}
resource "azurerm_subnet" "qtpub" {
  count                = length(var.subnet.names)
  name                 = var.subnet.names[count.index]
  resource_group_name  = var.resource_group_name.name
  virtual_network_name = azurerm_virtual_network.qtvnet.name
  address_prefixes     = [cidrsubnet(var.vnet.address_space[0], 8, count.index)]
  depends_on = [
    azurerm_resource_group.qtrg,
    azurerm_virtual_network.qtvnet
  ]
}
resource "azurerm_network_security_group" "qtsg" {
  name                = "qtsg"
  resource_group_name = var.resource_group_name.name
  location            = var.resource_group_name.location

  security_rule {
    name                       = "openssh"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "openhttp"
    priority                   = 310
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  depends_on = [
    azurerm_resource_group.qtrg
  ]
}
resource "azurerm_network_interface" "qtnic" {
  name                = "qtnic"
  location            = var.resource_group_name.location
  resource_group_name = var.resource_group_name.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.qtpub[0].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.qtip.id
  }
  depends_on = [
    azurerm_subnet.qtpub,
    azurerm_public_ip.qtip

  ]

}

resource "azurerm_public_ip" "qtip" {
  name                = "qtip"
  resource_group_name = var.resource_group_name.name
  location            = var.resource_group_name.location
  allocation_method   = "Static"
  depends_on = [
    azurerm_resource_group.qtrg
  ]
}
resource "azurerm_network_interface_security_group_association" "webnic_nsg_assc" {
  network_interface_id      = azurerm_network_interface.qtnic.id
  network_security_group_id = azurerm_network_security_group.qtsg.id

  depends_on = [
    azurerm_network_security_group.qtsg,
    azurerm_network_interface.qtnic
  ]

}