terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

resource "azurerm_data_factory" "main" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  identity {
    type = "SystemAssigned"
  }

  public_network_enabled          = var.public_network_enabled
  managed_virtual_network_enabled = var.managed_virtual_network_enabled

  customer_managed_key_id         = var.customer_managed_key_id
  customer_managed_key_identity_id = var.customer_managed_key_identity_id

  dynamic "github_configuration" {
    for_each = var.github_configuration != null ? [var.github_configuration] : []
    content {
      account_name    = github_configuration.value.account_name
      branch_name     = github_configuration.value.branch_name
      repository_name = github_configuration.value.repository_name
      root_folder     = github_configuration.value.root_folder
      git_url         = github_configuration.value.git_url
    }
  }

  tags = var.tags
}