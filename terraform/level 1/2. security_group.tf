
resource "aws_security_group" "devops_sg" {
    name = "devops-sg"
    description = "Security group for Nautilus App Servers"
     ingress {
        description = "HTTP"
        from_port = 80
        protocol = "tcp"
        to_port = 80
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "SSH"
        from_port = 22
        protocol = "tcp"
        to_port = 22
        cidr_blocks = ["0.0.0.0/0"]
    }
}