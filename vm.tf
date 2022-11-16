resource "azurerm_linux_virtual_machine" "sahithivm" {
  count=2
  
  name                = var.linux_virtual_machine_name[count.index]
  resource_group_name = var.resource_group_name
  location            = var.resource_group_name
  size                = "Standard_B1s"
  admin_username      = "satya"
  network_interface_ids = [
    azurerm_network_interface.qtnic.id,
  ]
  depends_on = [
    azurerm_resource_group.qtrg,
    
  ]

  admin_ssh_key {
    username   = "satya"
    public_key = file("~/.ssh/id_rsa.pub")
  }

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
resource "null_resource" "qtnull" {
  triggers = {
    triggers = "3"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt update && sudo apt install apache2 wget -y",
      "sudo apt install openjdk-11-jdk -y"
    ]
    connection {
      type        = "ssh"
      user        = "satya"
      private_key = file("~/.ssh/id_rsa")
      host        = azurerm_public_ip.qtip.ip_address
    }
  }
  depends_on = [
    azurerm_linux_virtual_machine.sahithivm
  ]
}
