# variables.tf
variable "KKE_VPC_NAME" {
    type = string
}

variable "KKE_SUBNET_NAME" {
    type = string
}

# main.tf
resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = var.KKE_VPC_NAME
    }
}

resource "aws_subnet" "subnet" {
    vpc_id = aws_vpc.vpc.id
    depends_on = [aws_vpc.vpc]
    cidr_block = "10.0.1.0/24"
    tags = {
        Name = var.KKE_SUBNET_NAME 
    }
}

# output.tf
output "kke_vpc_name" {
    value = aws_vpc.vpc.tags["Name"]
}

output "kke_subnet_name" {
    value = aws_subnet.subnet.tags["Name"]
}

# terraform.tfvars
KKE_VPC_NAME = "devops-vpc"
KKE_SUBNET_NAME = "devops-subnet"
