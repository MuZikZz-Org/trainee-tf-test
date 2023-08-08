terraform {  
  backend  "azurerm" {  
    resource_group_name  = "rg-ais-payment-gateway"
    storage_account_name = "sbpocstoacc"
    container_name       = "tfstatetest"
    key                  = "terraform.tfstate"
  }
}
