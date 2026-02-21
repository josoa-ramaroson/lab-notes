resource "aws_eip" "nautilus_eip" {
    domain = "vpc"
    tags = {
        Name = "nautilus-eip"
    }
}