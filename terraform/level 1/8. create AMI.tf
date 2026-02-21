resource "aws_instance" "ec2" {
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    "sg-a448aa45721ad2d04"
  ]

  tags = {
    Name = "nautilus-ec2"
  }
}

resource "aws_ami_from_instance" "nautilus_ec2_ami" {
    name = "nautilus-ec2-ami"
    source_instance_id = aws_instance.ec2.id
}