variable "resource_group_name" {
  description = "value of the resource group name"
  type = string
}
variable "resource_group_location" {
  description = "value of the resource group location"
  type = string
  
}

variable "storage_account_name" {
  description = "value of the storage account name"
  type = string
}

variable "container_name" {
  description = "value of the container name"
  type = string
}

variable "virtual_network_name" {
  description = "value of the virtual network name"
  type = string
  
}

variable "address_space" {
  description = "value of the address space"
  type = list(string)
}

variable "subnet_name" {
  description = "value of the subnet name"
  type = string
}

variable "subnet_address_prefix" {
  description = "value of the subnet address prefix"
  type = list(string)
}


variable "network_security_group_name" {
  description = "value of the network security group name"
  type = string
}

variable "security_rule_name" {
  description = "value of the security rule name"
  type = string
}

variable "priority" {
  description = "value of the priority"
  type = number
}




variable "vm-nic-name" {
  description = "value of the vm-nic"
  type = string
  
}

variable "vm-name" {
  description = "value of the vm-name"
  type = string
  
}