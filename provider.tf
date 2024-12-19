provider "azurerm" {
  # skip_provider_registration = "true"
  subscription_id = "3ca95b33-5a84-43c6-b2b3-0ad5986408f5"
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.75.0"
    }

  }
}