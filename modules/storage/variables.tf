variable "tags" {
  type = object({
    Name = string
  })
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "account_tier" {
  type    = string
  default = "Standard"
}

variable "account_replication_type" {
  type    = string
  default = "LRS"
}

variable "account_kind" {
  type    = string
  default = "StorageV2"
}

variable "container" {
  type = object({
    name         = string
    access_type  = string
    static_index = optional(string)
  })
}
