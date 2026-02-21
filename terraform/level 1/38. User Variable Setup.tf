variable KKE_user {
    type = string
    default = "iamuser_mariyam"
}

resource "aws_iam_user" "user" {
    name = var.KKE_user
}