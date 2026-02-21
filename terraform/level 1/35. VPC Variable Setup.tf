# variables.tf
variable "KKE_vpc" { 
    type = string
    default = "datacenter-vpc"
}
# main.tf

resource "aws_vpc" "datacenter_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = var.KKE_vpc
    }
}