output "kke_kinesis_stream_name" {
  value = aws_kinesis_stream.datacenter_kinesis_stream.name
}

output "kke_kinesis_alarm_name" {
  value = aws_cloudwatch_metric_alarm.datacenter_kinesis_alarm.alarm_name
}


 
   