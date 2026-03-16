resource "aws_kinesis_stream" "datacenter_kinesis_stream" {
  name = "datacenter-kinesis-stream"
  shard_count = 1
  shard_level_metrics = [
    "ReadProvisionedThroughputExceeded",
    "WriteProvisionedThroughputExceeded"
    ]
}

resource "aws_cloudwatch_metric_alarm" "datacenter_kinesis_alarm" {
  alarm_name = "datacenter-kinesis-alarm"
  metric_name = "WriteProvisionedThroughputExceeded"
  comparison_operator = "GreaterThanThreshold"
  namespace = "AWS/Kinesis"
  statistic = "Sum"
  evaluation_periods = 1
  threshold = 1
  period = 60
}
