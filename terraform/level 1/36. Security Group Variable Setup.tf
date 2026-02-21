variable "KKE_sg" {
    type = string
    default = "xfusion-sg"
}

resource "aws_security_group" "sg" {
    name = var.KKE_sg
}