variable "tags" {
  type = object({
    Name = string
  })
}
variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "cidr" {
  type = list(string)
}

variable "subnets" {
  type = map(object({
    cidr = list(string)
  }))
}
