variable "location" {
  type    = string
  default = "northeurope"
}

variable "ssh-source-address" {
  type    = string
  default = "*"
}

variable "subnet_config"{
  default = [
    {
      name   = "subnet1"
      ip_address = "10.0.0.0/28"
    },
    {
      name   = "subnet2"
      ip_address = "10.0.0.16/28"
    },
    {
      name   = "subnet3"
      ip_address = "10.0.0.32/28"
    },
    {
      name   = "subnet4"
      ip_address = "10.0.0.48/28"
    },
    {
      name   = "subnet5"
      ip_address = "10.0.0.64/28"
    },
    {
      name   = "subnet6"
      ip_address = "10.0.0.96/28"
    },
    {
      name   = "subnet7"
      ip_address = "10.0.0.112/28"
    },
  ]
}