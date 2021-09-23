variable "gitlab_vm_name" {
  type        = string
  description = "Name for the GitLab Virtual Machine"
}

variable "key_vault_id" {
  type        = string
  description = "Key Vault ID for the SSH Keys"
}

variable "create_public_ip" {
  type        = bool
  default     = false
  description = "Create a public IP for the GitLab Virtual Machine"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group Name for GitLab resources"
}

variable "vm_subnet_id" {
  type        = string
  description = "Subnet ID for the GitLab Virtual Machine"
}

variable "vm_size" {
  type        = string
  description = "Azure Virtual Machine SKU for Gitlab Virtual Machine"
  default     = "Standard_DS2_v2"
}

variable "dns_label" {
  type        = string
  description = "DNS Name for the Public IP"
  default     = ""
}
variable "location" {
  type = string
}