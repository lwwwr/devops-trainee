resource "aws_autoscaling_group" "alavruschik_agents" {
  availability_zones = var.availability_zones
  name = "alavruschik_agents"
  max_size = "3"
  min_size = "2"
  health_check_grace_period = 60
  health_check_type = "EC2"
  desired_capacity = 2
  vpc_zone_identifier = aws_subnet.alavruschik_private_backend_subnet.*.id
  force_delete = true
  target_group_arns = [aws_alb_target_group.alavruschik_alb_target_group.arn]
  launch_configuration = aws_launch_configuration.alavruschik_launch_configuration.name

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "alavruschik_private_backend_ec2-default"
  }
}

resource "aws_autoscaling_policy" "alavruschik_agents_scale_up" {
  name = "alavruschik_agents_scale_up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 60
  autoscaling_group_name = aws_autoscaling_group.alavruschik_agents.name
  policy_type = "SimpleScaling"
}

resource "aws_autoscaling_policy" "alavruschik_agents_scale_down" {
  name = "alavruschik_agents_scale_down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 60
  autoscaling_group_name = aws_autoscaling_group.alavruschik_agents.name
}

resource "aws_cloudwatch_metric_alarm" "alavruschik_memory_high" {
  alarm_name = "alavruschik_cpu_high_agents"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "60"
  statistic = "Average"
  threshold = "8"
  alarm_description = "This metric monitors ec2 cpu for high utilization on agent hosts"
  alarm_actions = [
    aws_autoscaling_policy.alavruschik_agents_scale_up.arn,
    aws_sns_topic.alavruschik_agent_sns.arn
  ]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.alavruschik_agents.name
  }
}

resource "aws_cloudwatch_metric_alarm" "alavruschik_memory_low" {
  alarm_name = "alavruschik_cpu_low_agents"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "60"
  statistic = "Average"
  threshold = "6"
  alarm_description = "This metric monitors ec2 cpu for low utilization on agent hosts"
  alarm_actions = [
    aws_autoscaling_policy.alavruschik_agents_scale_down.arn,
    aws_sns_topic.alavruschik_agent_sns.arn
  ]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.alavruschik_agents.name
  }
}