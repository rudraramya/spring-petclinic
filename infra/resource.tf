resource "azurerm_resource_group" "rudrars" {
  name     = "ramya"
  location = "Canada Central"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "madhu"
  location            = azurerm_resource_group.rudrars.location
  resource_group_name = azurerm_resource_group.rudrars.name
  address_space       = ["10.0.0.0/16"]
depends_on = [
  azurerm_resource_group.rudrars
]
}
resource "azurerm_subnet" "subnet" {
  name                 = "sub"
  resource_group_name  = azurerm_resource_group.rudrars.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}
resource "azurerm_public_ip" "ip" {
  name                = "public"
  resource_group_name = azurerm_resource_group.rudrars.name
  location            = azurerm_resource_group.rudrars.location
  allocation_method   = "Static"
  depends_on = [
    azurerm_subnet.subnet
  ]
}

resource "azurerm_network_interface" "nic" {
  name                = "network"
  location            = azurerm_resource_group.rudrars.location
  resource_group_name = azurerm_resource_group.rudrars.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    public_ip_address_id          = azurerm_public_ip.ip.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [
    azurerm_public_ip.ip
  ]
}
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "virtualmachine"
  resource_group_name = azurerm_resource_group.rudrars.name
  location            = azurerm_resource_group.rudrars.location
  size                = "Standard_B1s"
  admin_username      = "rudraramya"
  admin_password      = "Ramya$123456"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

}
resource "null_resource" "cluster" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    ver = 2
  }
connection {
    type     = "ssh"
    user     = "rudraramya"
    password = "Ramya$123456"
    host     = element(azurerm_virtual_network.azurerm.public_ip, 0)
  }
provisioner "file" {
    source      = "/home/rudraramya/common/workspace/spc/target/spring-petclinic-3.0.0-SNAPSHOT.jar"
    destination = "/home/rudraramya/"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt update ",
      "sudo apt install openjdk-17-jdk -y",
      "java -jar spring-petclinic-3.0.0-SNAPSHOT.jar "
    ]
  }

   
}