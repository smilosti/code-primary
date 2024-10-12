variable "pm_api_url" {
  description = "The API URL for the Proxmox server."
  type        = string
}

variable "pm_user" {
  description = "The user for the Proxmox server."
  type        = string
}

variable "pm_password" {
  description = "The password for the Proxmox server."
  type        = string
}

variable "pm_tls_insecure" {
  description = "TLS Insecure option for Proxmox server."
  type        = bool
  default     = true
}

variable "vm_name" {
  description = "Name of the VM."
  type        = string
}

variable "vm_id" {
  description = "ID of the VM."
  type        = number
}

variable "memory" {
  description = "Memory for the VM."
  type        = number
}

variable "cores" {
  description = "Number of CPU cores for the VM."
  type        = number
}

variable "sockets" {
  description = "Number of CPU sockets for the VM."
  type        = number
}

variable "bridge" {
  description = "Network bridge for the VM."
  type        = string
}

variable "storage" {
  description = "Storage location for the VM."
  type        = string
}

variable "disk_image" {
  description = "Disk image for the VM."
  type        = string
}

variable "disk_size" {
  description = "Size of the VM disk."
  type        = string
}

variable "efi_disk_size" {
  description = "Size of the EFI disk."
  type        = string
}

variable "template_id" {
  description = "ID of the template."
  type        = number
}

variable "target_node" {
  description = "Target Proxmox node."
  type        = string
}
