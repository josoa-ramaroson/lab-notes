resource "aws_vpc" "xfusion_vpc" {
    cidr_block = "192.168.0.0/24"
    assign_generated_ipv6_cidr_block = true
    enable_dns_hostnames = true 
    enable_dns_support = true
    tags = {
        Name = "xfusion-vpc"
    }
}

// mila jerena ito ambany ito fa ny doc milaza hoe io
resource "aws_vpc_ipv6_cidr_block_association" "ipv6_xfusion" {
    vpc_id = aws_vpc.xfusion_vpc.id
}