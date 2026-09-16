variable "location" {
  description = "Azure region used for Block 2 resources"
  type        = string
  default     = "polandcentral"
}

variable "resource_group_name" {
  description = "Resource group for the Block 2 security lab"
  type        = string
  default     = "rg-block2-security-lab"
}

variable "keyvault_secrets_officer_principal_id" {
  description = "Principal ID assigned Key Vault Secrets Officer for the Block 2 lab"
  type        = string
}