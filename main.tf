terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
#  backend "azurerm" {
#    resource_group_name  = "rg-ais-payment-gateway"
#    storage_account_name = "sbpocstoacc"
#    container_name       = "tfstatetest"
#    key                  = "terraform.tfstate"
#  }
}

provider "azurerm" {
  features {}
}



data "azurerm_resource_group" "rg" {
  name     = "rg-ais-payment-gateway"
}

# Create virtual network
resource "azurerm_virtual_network" "my_terraform_network" {
  name                = "myVnet"
  address_space       = ["10.0.0.0/16"]
  location            = "SoutheastAsia"
  resource_group_name = "rg-ais-payment-gateway"
  tags = {
    environment = "sandbox"
    company =  "techx"
    emailowner = "pongsathorn.upan@scbtechx.io"
    project = "AIS-Payment-gateway"
    validdate = "30Sep2023"
  }
}

# Create subnet
resource "azurerm_subnet" "my_terraform_subnet" {
  name                 = "mySubnet"
  resource_group_name  = "rg-ais-payment-gateway"
  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "my_terraform_public_ip" {
  name                = "myPublicIP"
  location            = "SoutheastAsia"
  resource_group_name = "rg-ais-payment-gateway"
  allocation_method   = "Dynamic"
      tags = {
    environment = "sandbox"
    company =  "techx"
    emailowner = "pongsathorn.upan@scbtechx.io"
    project = "AIS-Payment-gateway"
    validdate = "30Sep2023"
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "my_terraform_nsg" {
  name                = "myNetworkSecurityGroup"
  location            = "SoutheastAsia"
  resource_group_name = "rg-ais-payment-gateway"

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
    tags = {
    environment = "sandbox"
    company =  "techx"
    emailowner = "pongsathorn.upan@scbtechx.io"
    project = "AIS-Payment-gateway"
    validdate = "30Sep2023"
  }
}

# Create network interface
resource "azurerm_network_interface" "my_terraform_nic" {
  name                = "myNIC"
  location            = "SoutheastAsia"
  resource_group_name = "rg-ais-payment-gateway"

  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = azurerm_subnet.my_terraform_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
  }
    tags = {
    environment = "sandbox"
    company =  "techx"
    emailowner = "pongsathorn.upan@scbtechx.io"
    project = "AIS-Payment-gateway"
    validdate = "30Sep2023"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.my_terraform_nic.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id

}



# Create storage account for boot diagnostics
resource "azurerm_storage_account" "my_storage_account" {
  name                     = "diagtest1230031020"
  location                 = "SoutheastAsia"
  resource_group_name      = "rg-ais-payment-gateway"
  account_tier             = "Standard"
  account_replication_type = "LRS"
      tags = {
    environment = "sandbox"
    company = "techx"
    emailowner = "pongsathorn.upan@scbtechx.io"
    project = "AIS-Payment-gateway"
    validdate = "30Sep2023"
  }
}

# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  name                  = "vm-trainee-test"
  location              = "SoutheastAsia"
  resource_group_name   = "rg-ais-payment-gateway"
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = "myvmtest"
  admin_username                  = "admin@123"
  admin_password                  = "Admin@999"
  disable_password_authentication = false

  admin_ssh_key {
    username   = "natthidak"
    public_key = tls_private_key.example_ssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  }
  tags = {
    environment = "sandbox"
    company =  "techx"
    emailowner = "pongsathorn.upan@scbtechx.io"
    project = "AIS-Payment-gateway"
    validdate = "30Sep2023"
  }
}
