# Create IAM user
resource "aws_iam_user" "user" {
  name = "iamuser_rose"

  tags = {
    Name = "iamuser_rose"
  }
}

# Create IAM Policy
resource "aws_iam_policy" "policy" {
  name        = "iampolicy_rose"
  description = "IAM policy allowing EC2 read actions for rose"

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

resource "aws_iam_user_policy_attachment" "attach_iam_policy_to_imuser_rose" {
  user = aws_iam_user.user.name
  policy_arn = aws_iam_policy.policy.arn
}