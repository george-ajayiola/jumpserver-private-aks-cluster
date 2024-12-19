output "vm_name" {
  description = "The name of the virtual machine"
  value       = azurerm_linux_virtual_machine.vm1.name
}

output "azurerm_bastion_host" {
  description = "name of bastion host"
  value = azurerm_bastion_host.bastion.name
}

output "azurerm_public_ip" {
  description = "public ip address of bastion host"
  value = azurerm_public_ip.bastion-pip.ip_address
}