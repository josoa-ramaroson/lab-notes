# variables.tf

variable "KKE_VPC_CIDR" {
    type= string
    default = "10.0.0.0/16"
}

variable "KKE_SUBNET_CIDR" {
    type = string
    default =  "10.0.1.0/24"
}
# the variable part here is from github.com/imShakil/100-Days-Of-DevOps-Challenge-KodeKloud/blob/main/days/098.md
# It is not part of the instruction
variable "prefix" {
    type = string
    default = "datacenter-priv"
}

# main.tf
resource "aws_vpc" "vpc" {
    cidr_block = var.KKE_VPC_CIDR
    tags = {
        Name = "${var.prefix}-vpc"
    }
}

resource "aws_subnet" "subnet" {
    vpc_id = aws_vpc.vpc.id 
    cidr_block = var.KKE_SUBNET_CIDR
    map_public_ip_on_launch = false
    tags = {
        Name = "${var.prefix}-subnet"
    }
}

resource "aws_security_group" "allow_only_access_within_vpc" {
    description = "Allows access only inside the vpc"
    vpc_id = aws_vpc.vpc.id

    name = "${var.prefix}-sg"
    tags = {
      Name = "${var.prefix}-sg" 
    }
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_inside_vpc" {
    security_group_id = aws_security_group.allow_only_access_within_vpc.id 
    cidr_ipv4 = var.KKE_VPC_CIDR
    ip_protocol = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_egress" {
    security_group_id = aws_security_group.allow_only_access_within_vpc.id 
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}
# If we asign the subnet by interface
# resource "aws_network_interface" "priv_ec2_cart" {
#     subnet_id = aws_subnet.subnet.id
# }

data "aws_ami" "amazon_linux_2023" {
    most_recent = true
    owners = ["amazon"]

    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-ebs"]
    }
}

resource "aws_instance" "priv_ec2" {
    ami           =  data.aws_ami.amazon_linux_2023.id
    instance_type = "t2.micro" 
    vpc_security_group_ids = [aws_security_group.allow_only_access_within_vpc.id]
    subnet_id = aws_subnet.subnet.id
    # If we asign the subnet by interface
    # primary_networknetwork_interface {
    #   network_interface_id = aws_network_interface.priv_ec2_cart.id
    # }

    tags = {
        Name = "${var.prefix}-ec2"
    } 
}

# outputs.tf
output "KKE_vpc_name" {
    value = aws_vpc.vpc.tags["Name"]
}

output "KKE_subnet_name" {
    value = aws_subnet.subnet.tags["Name"]
}

output "KKE_ec2_private" {
    value = aws_instance.priv_ec2.tags["Name"]
}
