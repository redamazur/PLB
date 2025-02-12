resource "azurerm_linux_virtual_machine" "Prod-Web-vm" {
    name                  = "Prod-Web-VM"
    location              = data.azurerm_resource_group.rg_Dev.location
    resource_group_name   = data.azurerm_resource_group.rg_Dev.name
    network_interface_ids = [azurerm_network_interface.web_Prod_01_nic.id]
    size                  = "Standard_DS1_v2"

    os_disk {
        name              = "Prod-Web-Disk"
        caching           = "ReadWrite"
        # storage_account_type = "Premium_LRS"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    computer_name  = "Prod-Web-vm"
    admin_username = "azureuser"
    disable_password_authentication = true

    admin_ssh_key {
        username       = "azureuser"
        public_key     = tls_private_key.Dev_Web_ssh.public_key_openssh
    }


    tags = {
        environment = "Terraform Demo"
    }
}
