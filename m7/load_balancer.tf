resource "aws_alb" "alavruschik_backend_alb" {
  name = "alavruschik-backend-alb"
  subnets = aws_subnet.alavruschik_private_backend_subnet.*.id
  internal = true
  security_groups = [
  aws_security_group.alavruschik_sg_vpc_traffic.id
  ]
  idle_timeout = 10
  tags = merge(
    var.tags, 
    map(
    "Name", "alavruschik_backend_alb"
  ))
}

resource "aws_alb_target_group" "alavruschik_backend_alb_target_group" {
  name = "alavruschik-backend-alb-tg"
  port = 8080
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
    "Name", "alavruschik_backend_alb_target_group"
  ))
}

resource "aws_alb" "alavruschik_frontend_alb" {
  name = "alavruschik-frontend-alb"
  subnets = aws_subnet.alavruschik_public_subnet.*.id
  security_groups = [
  aws_security_group.alavruschik_sg_vpc_traffic.id,
  aws_security_group.alavruschik_sg_incoming.id
  ]
  idle_timeout = 10
  tags = merge(
    var.tags, 
    map(
    "Name", "alavruschik_frontend_alb"
  ))
}

resource "aws_alb_target_group" "alavruschik_frontend_alb_target_group" {
  name = "alavruschik-frontend-alb-tg"
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
    "Name", "alavruschik_frontend_alb_target_group"
  ))
}

# resource "aws_alb_target_group_attachment" "alavruschik_alb_target_group_attachment" {
#   count = length(var.availability_zones)
#   target_group_arn = aws_alb_target_group.alavruschik_alb_target_group.arn
#   target_id = element(aws_instance.alavruschik_private_backend_ec2.*.id, count.index)
#   #availability_zone = element(var.availability_zones, count.index)
#   port = 8080
# }

data "aws_acm_certificate" "alavruschik_ssl_cert_data" {
  domain      = "*.test.coherentprojects.net"
  statuses    = ["ISSUED"]
  most_recent = true
}

resource "aws_alb_listener" "alavruschik_backend_alb_http" {
  load_balancer_arn = aws_alb.alavruschik_backend_alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.alavruschik_backend_alb_target_group.arn
  }
}

resource "aws_alb_listener" "alavruschik_backend_alb_https" {
  load_balancer_arn = aws_alb.alavruschik_backend_alb.arn
  port = "443"
  protocol = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.alavruschik_ssl_cert_data.arn

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.alavruschik_backend_alb_target_group.arn
  }
}

resource "aws_alb_listener" "alavruschik_frontend_alb_http" {
  load_balancer_arn = aws_alb.alavruschik_frontend_alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.alavruschik_frontend_alb_target_group.arn
  }
}

resource "aws_alb_listener" "alavruschik_frontend_alb_https" {
  load_balancer_arn = aws_alb.alavruschik_frontend_alb.arn
  port = "443"
  protocol = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.alavruschik_ssl_cert_data.arn

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.alavruschik_frontend_alb_target_group.arn
  }
}