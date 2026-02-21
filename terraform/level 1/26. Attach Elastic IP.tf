# Provision EC2 instance
resource "aws_instance" "ec2" {
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t2.micro"
  subnet_id     = "subnet-eb51158b2b9db75be"
  vpc_security_group_ids = [
    "sg-8a3789310e0d8d392"
  ]

  tags = {
    Name = "datacenter-ec2"
  }
}

# Provision Elastic IP
resource "aws_eip" "ec2_eip" {
  instance = aws_instance.ec2.id 
  tags = {
    Name = "datacenter-ec2-eip"
  }
}

# or 
resource "aws_eip" "ec2_eip" {
  tags = {
    Name = "datacenter-ec2-eip"
  }
}

resource "aws_eip_association" "eip_assoc"{
    instance_id = aws_instance.ec2.id
    allocation_id = aws_eip.ec2_eip.id
}