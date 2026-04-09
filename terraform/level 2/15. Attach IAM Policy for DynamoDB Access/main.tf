resource "aws_dynamodb_table" "name" {
   name = var.KKE_TABLE_NAME
   hash_key = "devops_id"
    billing_mode = "PAY_PER_REQUEST"
    attribute {
        name = "devops_id"
        type = "S"
    }
}


data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "devops_role" {
  name               = var.KKE_ROLE_NAME
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

data "aws_iam_policy_document" "readonly_dynamodb" {
  statement {
    actions = ["dynamodb:GetItem", "dynamodb:Scan", "dynamodb:Query"]
    effect   = "Allow"
    resources = [
      aws_dynamodb_table.name.arn
    ]
  }
}
resource "aws_iam_policy" "devops_policy" {
  name = var.KKE_POLICY_NAME
  policy = data.aws_iam_policy_document.readonly_dynamodb.json
}


resource "aws_iam_role_policy_attachment" "devops_policy_attachment" {
  role       = aws_iam_role.devops_role.name
  policy_arn = aws_iam_policy.devops_policy.arn
}