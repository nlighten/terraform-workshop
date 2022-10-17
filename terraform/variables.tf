variable "workshop_user" {
  type        = string
  description = "Your name"
  default     = "changeme"
}

variable "vm_password" {
  type        = string
  description = "Password of the vm"
  default     = "ChangeMe123456789!"
}

variable "location" {
  type        = string
  description = "Azure Region"
  default     = "westeurope"
}

variable "team" {
  type        = string
  description = "Team name"
  default     = "knowit"
}
