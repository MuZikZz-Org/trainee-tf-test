terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.46.0"
    }
  }
}

provider "azurerm" {
  subscription_id  =  var.ARM_SUBSCRIPTION_ID
  tenant_id  =  var.ARM_TENANT_ID  
  client_id  =  var.ARM_CLIENT_ID
  client_secret  =  var.ARM_CLIENT_SECRET
  features {}
}