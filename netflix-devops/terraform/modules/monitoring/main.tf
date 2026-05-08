# main.tf

resource "aws_cloudwatch_metric_alarm" "high_cpu" {

  alarm_name = "${var.project_name}-high-cpu"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 2

  metric_name = "CPUUtilization"

  namespace = "AWS/EC2"

  period = 120

  statistic = "Average"

  threshold = 80

  alarm_description = "Triggers when CPU exceeds 80%"

  dimensions = {
    InstanceId = var.instance_id
  }

}