resource_group_name = "clouddevinsights"
resource_group_location = "Australia East"
storage_account_name = "clouddevinsightsstorage"
container_name = "terraformstate"
virtual_network_name = "clouddevinsights-vnet"
address_space = ["10.0.0.0/16"]
subnet_name = "clouddevinsights-subnet"
subnet_address_prefix = ["10.0.1.0/24"]
network_security_group_name = "clouddevinsights-nsg"
security_rule_name = "allow-ssh-hhtp"
priority = 120
vm-nic-name = "clouddevinsights-nic"
vm-name = "clouddevinsights-vm"