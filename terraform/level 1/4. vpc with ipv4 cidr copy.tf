resource "aws_vpc" "datacenter_vpc" {
    cidr_block = "192.168.0.0/24"
    tags = {
        Name = "datacenter-vpc"
    }
}