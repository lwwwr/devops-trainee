resource "aws_sns_topic" "alavruschik_agent_sns" {
  name = "alavruschik_agent_sns"
}

# resource "aws_sns_topic_subscription" "alavruschik_agent_email_target" {
#   topic_arn = aws_sns_topic.alavruschik_agent_sns.arn
#   protocol  = "email"
#   endpoint  = var.subscription_email
# }


resource "aws_autoscaling_notification" "alavruschik_agent_notification" {
  group_names = [
    aws_autoscaling_group.alavruschik_backend_agents.name,
    aws_autoscaling_group.alavruschik_frontend_agents.name
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.alavruschik_agent_sns.arn
}

resource "aws_ses_email_identity" "alavrschik_email" {
  email = "artemlavruschik@coherentsolutions.com"
}

resource "aws_ses_identity_notification_topic" "alavruschik_send_email" {
  topic_arn = aws_sns_topic.alavruschik_agent_sns.arn
  notification_type = "Bounce"
  identity = aws_ses_email_identity.alavrschik_email.arn
  include_original_headers = true
}