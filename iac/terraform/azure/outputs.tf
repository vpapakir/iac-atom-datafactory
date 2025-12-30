output "data_factory_id" {
  description = "The ID of the Data Factory"
  value       = azurerm_data_factory.main.id
}

output "data_factory_name" {
  description = "The name of the Data Factory"
  value       = azurerm_data_factory.main.name
}

output "identity_principal_id" {
  description = "The Principal ID of the System Assigned Managed Service Identity"
  value       = azurerm_data_factory.main.identity[0].principal_id
}

output "identity_tenant_id" {
  description = "The Tenant ID of the System Assigned Managed Service Identity"
  value       = azurerm_data_factory.main.identity[0].tenant_id
}