terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "rg-datafactory-example"
  location = "East US"
}

module "data_factory" {
  source = "../../iac/terraform/azure"

  name                = "adf-example-dev"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  public_network_enabled          = true
  managed_virtual_network_enabled = true

  tags = {
    Environment = "dev"
    Project     = "iac-atom-datafactory"
    ManagedBy   = "terraform"
  }
}

output "data_factory_details" {
  value = {
    id                 = module.data_factory.data_factory_id
    name               = module.data_factory.data_factory_name
    identity_principal = module.data_factory.identity_principal_id
  }
}