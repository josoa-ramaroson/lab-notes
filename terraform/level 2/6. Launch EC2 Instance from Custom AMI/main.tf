# Provision EC2 instance
resource "aws_instance" "ec2" {
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    "sg-37571c02412538bcd"
  ]

  tags = {
    Name = "devops-ec2"
  }
}

# AMI creation from this resource
resource "aws_ami_from_instance" "devops_ec2_ami" {
  name = "devops-ec2-ami"
  source_instance_id = aws_instance.ec2.id
}       

resource "aws_instance" "new_ec2" {
  ami = aws_ami_from_instance.devops_ec2_ami.id
  instance_type = "t2.micro"
  tags = {
    "Name" = "devops-ec2-new"
  }
}