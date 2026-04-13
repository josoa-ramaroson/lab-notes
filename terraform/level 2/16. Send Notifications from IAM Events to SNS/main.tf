resource "aws_sns_topic" "xfusion" {
  name = local.KKE_SNS_TOPIC_NAME
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

resource "aws_iam_role" "xfusion" {
  name = local.KKE_ROLE_NAME
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

data "aws_iam_policy_document" "publish_to_sns_topic" {
  statement {
    actions = ["sns:Publish"]
    effect   = "Allow"
    resources = [
      aws_sns_topic.xfusion.arn
    ]
  }
}
resource "aws_iam_policy" "xfusion" {
  name = local.KKE_POLICY_NAME
  policy = data.aws_iam_policy_document.publish_to_sns_topic.json
}

resource "aws_iam_role_policy_attachment" "xfusion_policy_attachment" {
  role       = aws_iam_role.xfusion.name
  policy_arn = aws_iam_policy.xfusion.arn
}