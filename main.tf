#data "azurerm_resource_group" "rg" {
# name     = "rg-ais-payment-gateway"
#}

# Create virtual network
resource "azurerm_virtual_network" "my_terraform_network" {
  name                = "trainee-Vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "SoutheastAsia"
  resource_group_name = "rg-ais-payment-gateway"
  tags = merge(
     var.env_tags
   )
}

# Create subnet
resource "azurerm_subnet" "my_terraform_subnet" {
  name                 = "trainee-Subnet"
  resource_group_name  = "rg-ais-payment-gateway"
  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "my_terraform_public_ip" {
  name                = "trainee-PublicIP"
  location            = "SoutheastAsia"
  resource_group_name = "rg-ais-payment-gateway"
  allocation_method   = "Dynamic"
      tags = merge(
     var.env_tags
   )
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "my_terraform_nsg" {
  name                = "trainee-NetworkSecurityGroup"
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
    tags = merge(
     var.env_tags
   )
}

# Create network interface
resource "azurerm_network_interface" "my_terraform_nic" {
  name                = "trainee-NIC"
  location            = "SoutheastAsia"
  resource_group_name = "rg-ais-payment-gateway"

  ip_configuration {
    name                          = "trainee_nic_configuration"
    subnet_id                     = azurerm_subnet.my_terraform_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
  }
    tags = merge(
     var.env_tags
   )
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
      tags = merge(
     var.env_tags
   )
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
    publisher = var.SRC_IMG_REF_PUBLISHER
    offer     = var.SRC_IMG_REF_OFFER
    sku       = var.SRC_IMG_REF_SKU
    version   = var.SRC_IMG_REF_VERSION
  }

  computer_name                   = "natthidak"
  admin_username                  = "natthidak"
  admin_password                  = "NatthidaK@16"
  disable_password_authentication = false

  admin_ssh_key {
    username   = "natthidak"
    public_key = tls_private_key.example_ssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  }

#   connection {
 #   type        = "ssh"
  #  host        = self.public_ip_address
   # user        = "natthidak"
#    password    = "NatthidaK@16"  # Replace with the admin password
 #   private_key =  tls_private_key.example_ssh.private_key_pem
  #}


#  provisioner "remote-exec" {
#    inline = [
#      "sudo apt-get update",
 #     "sudo apt-get install -y default-jre",
#      "wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.0.1.46107.zip",
#      "unzip sonarqube-9.0.1.46107.zip",
#      "sudo mv sonarqube-9.0.1.46107 /opt/sonarqube",
#      "sudo /opt/sonarqube/bin/linux-x86-64/sonar.sh start"
#    ]
#  }


  provisioner "remote-exec" {
    connection {
    type        = "ssh"
    host        = self.public_ip_address
    user        = "natthidak"
    password    = "NatthidaK@16"  # Replace with the admin password
    private_key =  tls_private_key.example_ssh.private_key_pem
    }
     script = "provisioner.sh"
  }

  tags = merge(
     var.env_tags
   )
}
