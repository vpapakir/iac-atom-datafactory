variable "name" {
  description = "The name of the Data Factory"
  type        = string
}

variable "location" {
  description = "The Azure region where the Data Factory should be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Data Factory"
  type        = string
}

variable "public_network_enabled" {
  description = "Is the Data Factory visible to the public network?"
  type        = bool
  default     = false
}

variable "managed_virtual_network_enabled" {
  description = "Is Managed Virtual Network enabled?"
  type        = bool
  default     = false
}

variable "github_configuration" {
  description = "GitHub configuration for the Data Factory"
  type = object({
    account_name    = string
    branch_name     = string
    repository_name = string
    root_folder     = string
    git_url         = string
  })
  default = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}