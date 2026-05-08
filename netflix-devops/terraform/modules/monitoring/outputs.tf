# outputs.tf

output "alarm_name" {
  description = "CloudWatch Alarm Name"

  value = aws_cloudwatch_metric_alarm.high_cpu.alarm_name
}