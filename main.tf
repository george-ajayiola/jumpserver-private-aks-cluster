data "azurerm_resource_group" "rg" {
  name     = "devops-stuff"
}

data "azurerm_virtual_network" "aks-vnet" {
  name                = "main"
  resource_group_name = data.azurerm_resource_group.rg.name
}


resource "azurerm_user_assigned_identity" "identity-vm" {
  name                = "identity-vm"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
}

resource "azurerm_role_assignment" "vm-contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.identity-vm.principal_id
}

data "azurerm_subscription" "current" {}


resource "azurerm_network_interface" "nic" {
  name                = "vm-nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm1" {
  name                = "jump-server-vm"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  custom_data = filebase64("postdeploy.sh")
  
#   This is optional, don't do this in prod though
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.identity-vm.id]
  }

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/my-key.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_public_ip" "bastion-pip" {
  name                = "bastion-public-ip"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = "bastion-jumpserver"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku = "Standard"

  tunneling_enabled = true #allows secure RDP/SSH connectivity 

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion-pip.id
  }
}


