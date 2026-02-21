
resource "tls_private_key" "rsa_pk" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "aws_key_pair" "datacenter_kp" {
    key_name = "devops-kp"
    public_key = tls_private_key.rsa_pk.public_key_openssh
}

data "aws_security_group" "default" {
    name = "default"
}

resource "aws_instance" "devops_ec2" {
    ami = "ami-0c101f26f147fa7fd"
    instance_type = "t2.micro" 
    vpc_security_group_ids = [data.aws_security_group.default.id]
    key_name = aws_key_pair.datacenter_kp.key_name
    tags = {
        Names = "devops-ec2"
    }
}