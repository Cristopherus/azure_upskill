variable "location" {
  type = string
}

variable "tags" {
  type = object({
    Name = string
  })
}

# variable "network" {
#   type = object({
#     cidr = list(string)
#     subnets = map(object({
#       cidr = list(string)
#     }))
#   })
# }

variable "containers" {
  type = map(object({
    name         = string
    access_type  = string
    static_index = optional(string)
  }))
}

variable "static_web" {
  type = object({
    name         = string
    access_type  = string
    static_index = optional(string)
  })
}

variable "function_name" {
  type = string
}
