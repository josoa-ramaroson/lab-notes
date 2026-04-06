resource "aws_sns_topic" "nautilus_sns_topic" {
  name = "nautilus-sns-topic"
}

resource "aws_sqs_queue" "nautilus_sqs_queue" {
  name = "nautilus-sqs-queue"
}

resource "aws_sqs_queue_policy" "allow_sns" {
  queue_url = aws_sqs_queue.nautilus_sqs_queue.id

  policy = data.aws_iam_policy_document.sqs_queue_policy.json
}

resource "aws_sns_topic_subscription" "sqs_subscriptions" {
  topic_arn = aws_sns_topic.nautilus_sns_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.nautilus_sqs_queue.arn
}

data "aws_iam_policy_document" "sqs_queue_policy" {
  statement {
    sid    = "AllowSNSToSendMessage"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    actions = [
      "sqs:SendMessage",
    ]

    resources = [
      aws_sqs_queue.nautilus_sqs_queue.arn,
    ]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"

      values = [
        aws_sns_topic.nautilus_sns_topic.arn,
      ]
    }
  }
}