resource "azurerm_subnet" "vm_subnet" {
  name                 = "junpserver-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.aks-vnet.name
  address_prefixes     = ["10.1.6.0/23"]
}

resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.aks-vnet.name
  address_prefixes     = ["10.1.4.0/23"]
}