provider "azurerm" {
  features {}
  subscription_id = "6baeb535-5ac9-402f-83c4-4aed96077df6"
}

terraform {
      backend "azurerm" {
    resource_group_name  = "__terraformrg__"             # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
    storage_account_name = "__terraformstorageaccount__"                                 # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "terraformstate"                                  # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "prod.terraform.tfstate"                   # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
    access_key           = "__storagekey__"  # Can also be set via `ARM_ACCESS_KEY` environment variable.
  }
}



resource "azurerm_resource_group" "clouddevinsights" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_storage_account" "backendstorage" {
  name                     = "clouddevinsightsstorage"
  resource_group_name      = azurerm_resource_group.clouddevinsights.name
  location                 = var.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "terraformbackend"
    owner       = "YourOwnerName"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.backendstorage.id
  container_access_type = "private"
}



resource "azurerm_virtual_network" "vnet-clouddevinsights" {
  name                = var.virtual_network_name
  address_space       = var.address_space
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "vnet-clouddevinsights-subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.clouddevinsights.name
  virtual_network_name = azurerm_virtual_network.vnet-clouddevinsights.name
  address_prefixes     = var.subnet_address_prefix
}

resource "azurerm_network_security_group" "nsg-clouddevinsights-nsg" {
  name                = var.network_security_group_name
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.clouddevinsights.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "vm-nic" {
  name                = var.vm-nic-name
  location            = azurerm_resource_group.clouddevinsights.location
  resource_group_name = azurerm_resource_group.clouddevinsights.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vnet-clouddevinsights-subnet.id
    private_ip_address_allocation = "Dynamic"
    
  }
   
}

resource "azurerm_network_interface_security_group_association" "nsg-association" {
  network_interface_id      = azurerm_network_interface.vm-nic.id
  network_security_group_id = azurerm_network_security_group.nsg-clouddevinsights-nsg.id
}

resource "azurerm_linux_virtual_machine" "linux-vm" {
  name                = var.vm-name
  resource_group_name = azurerm_resource_group.clouddevinsights.name
  location            = var.resource_group_location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  admin_password = "Password1234!"
  disable_password_authentication = "false"

  network_interface_ids = [
    azurerm_network_interface.vm-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
