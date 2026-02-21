resource "aws_cloudwatch_metric_alarm" "nautilu_alarm" {
    alarm_name = "nautilus-alarm"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods = 1
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = 300
    statistic = "Average"
    threshold = 80
}