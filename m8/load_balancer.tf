data "aws_acm_certificate" "alavruschik_ssl_cert_data" {
  domain      = "*.test.coherentprojects.net"
  statuses    = ["ISSUED"]
  most_recent = true
}

############### Nexus ###############
resource "aws_alb" "alavruschik_nexus_alb" {
  name = "alavruschik-nexus-alb"
  subnets = aws_subnet.alavruschik_public_subnet.*.id
  security_groups = [
  aws_security_group.alavruschik_sg_vpc_traffic.id,
  aws_security_group.alavruschik_sg_incoming.id
  ]
  idle_timeout = 10
  tags = merge(
    var.tags, 
    map(
    "Name", "alavruschik_nexus_alb"
  ))
}

resource "aws_alb_target_group" "alavruschik_nexus_alb_target_group" {
  name = "alavruschik-nexus-alb-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.alavruschik_vpc_main.id
  target_type = "instance"
  
  health_check {
    enabled = true
    interval = 6
    path = "/"
    port = "traffic-port"
    protocol = "HTTP"

  }

  tags = merge(
    var.tags, 
    map(
    "Name", "alavruschik_nexus_alb_target_group"
  ))
}

resource "aws_alb_target_group_attachment" "alavruschik_nexus_alb_target_group_attachment" {
  target_group_arn = aws_alb_target_group.alavruschik_nexus_alb_target_group.arn
  target_id = aws_instance.alavruschik_private_nexus_ec2.id
  port = 80
}

resource "aws_alb_listener" "alavruschik_nexus_alb_http" {
  load_balancer_arn = aws_alb.alavruschik_nexus_alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.alavruschik_nexus_alb_target_group.arn
  }
}

resource "aws_alb_listener" "alavruschik_nexus_alb_https" {
  load_balancer_arn = aws_alb.alavruschik_nexus_alb.arn
  port = "443"
  protocol = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.alavruschik_ssl_cert_data.arn

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.alavruschik_nexus_alb_target_group.arn
  }
}

############### Sonar Qube ###############

resource "aws_alb" "alavruschik_sonar-qube_alb" {
  name = "alavruschik-sonar-qube-alb"
  subnets = aws_subnet.alavruschik_public_subnet.*.id
  security_groups = [
  aws_security_group.alavruschik_sg_vpc_traffic.id,
  aws_security_group.alavruschik_sg_incoming.id
  ]
  idle_timeout = 10
  tags = merge(
    var.tags, 
    map(
    "Name", "alavruschik_sonar-qube_alb"
  ))
}

resource "aws_alb_target_group" "alavruschik_sonar-qube_alb_target_group" {
  name = "alavruschik-sonar-qube-alb-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.alavruschik_vpc_main.id
  target_type = "instance"
  
  health_check {
    enabled = true
    interval = 6
    path = "/"
    port = "traffic-port"
    protocol = "HTTP"

  }

  tags = merge(
    var.tags, 
    map(
    "Name", "alavruschik_sonar-qube_alb_target_group"
  ))
}

resource "aws_alb_target_group_attachment" "alavruschik_sonar-qube_alb_target_group_attachment" {
  target_group_arn = aws_alb_target_group.alavruschik_sonar-qube_alb_target_group.arn
  target_id = aws_instance.alavruschik_private_sonar-qube_ec2.id
  port = 80
}

resource "aws_alb_listener" "alavruschik_sonar-qube_alb_http" {
  load_balancer_arn = aws_alb.alavruschik_sonar-qube_alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.alavruschik_sonar-qube_alb_target_group.arn
  }
}

resource "aws_alb_listener" "alavruschik_sonar-qube_alb_https" {
  load_balancer_arn = aws_alb.alavruschik_sonar-qube_alb.arn
  port = "443"
  protocol = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.alavruschik_ssl_cert_data.arn

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.alavruschik_sonar-qube_alb_target_group.arn
  }
}
