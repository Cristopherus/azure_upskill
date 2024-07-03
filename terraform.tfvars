location = "West Europe"
tags = {
  Name = "krdziuban_upskill"
}

# network = {
#   cidr = ["10.0.0.0/16"]
#   subnets = {
#     "public" = {
#       cidr = ["10.0.1.0/24"]
#     },
#     "private" = {
#       cidr = ["10.0.2.0/24"]
#   } }
# }

containers = {
  first = {
    name        = "krdziuban1"
    access_type = "private"
  },
  second = {
    name        = "krdziuban2"
    access_type = "private"
  }
}

static_web = {
  name         = "krdziubanweb"
  access_type  = "blob"
  static_index = "webpage/index.html"
}

function_name = "krdziuban"
