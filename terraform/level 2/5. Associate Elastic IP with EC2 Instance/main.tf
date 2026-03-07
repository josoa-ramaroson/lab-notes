data "aws_ami" "amazon_linux_2" {
    most_recent = true 

    owners = ["amazon"]

    filter {
        name   = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

resource "aws_instance" "datacenter_ec2" {
    ami = data.aws_ami.amazon_linux_2.id
    instance_type = "t2.micro"
    tags = {
      "Name" = "datacenter-ec2"
    }
}

resource "aws_eip" "datacenter_eip" {
  domain = "vpc"
  tags = {
    "Name" = "datacenter-eip"
  }
}

resource "aws_eip_association" "datacenter_ec2" {
    instance_id = aws_instance.datacenter_ec2.id 
    allocation_id = aws_eip.datacenter_eip.id
}