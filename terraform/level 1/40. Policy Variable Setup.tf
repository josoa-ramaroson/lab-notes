variable KKE_iampolicy {
    type = string
    default = "iampolicy_james"
}

resource "aws_iam_policy" "role" {
    name = var.KKE_iampolicy
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect   = "Allow"
                Action   = ["ec2:Read*"]
                Resource = "*"
            }
        ]
    })
}