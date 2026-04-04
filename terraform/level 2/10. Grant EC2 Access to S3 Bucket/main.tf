
resource "aws_s3_bucket" "nautilus_logs" {
  bucket = var.KKE_BUCKET_NAME

  tags = {
    "Name" = var.KKE_BUCKET_NAME
  }
}
resource "aws_iam_role" "nautilus_role" {
  name = var.KKE_ROLE_NAME

  assume_role_policy = jsonencode({
     Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

}

resource "aws_iam_policy" "nautilus_access_policy" {
  name = var.KKE_POLICY_NAME
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:PutObject"]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.nautilus_logs.arn}/*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attache_access_policy_to_role" {
  role = aws_iam_role.nautilus_role.name 
  policy_arn = aws_iam_policy.nautilus_access_policy.arn
}

resource "aws_iam_instance_profile" "nautilus_ec2_profile" {
  name = "nautilus_ec2_profile"
  role = aws_iam_role.nautilus_role.name 
}

resource "aws_instance" "nautilus_ec2" {
  instance_type = "t3.micro"
  ami = data.aws_ami.amazon_linux_2.id 
  iam_instance_profile = aws_iam_instance_profile.nautilus_ec2_profile.name
  tags = {
    Name = "nautilus-ec2"
  }
}