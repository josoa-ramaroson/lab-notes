variable "KKE_eip" {
    type = string
    default = "datacenter-eip"
}

resource "aws_eip" "datacenter_eip" {
    tags = {
        Name = var.KKE_eip
    }
} 