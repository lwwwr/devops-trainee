data "aws_acm_certificate" "alavruschik_ssl_cert_data" {
  domain      = "*.test.coherentprojects.net"
  statuses    = ["ISSUED"]
  most_recent = true
}

  
resource "aws_alb" "alavruschik_alb" {
  name = "alavruschik-alb"
  subnets = aws_subnet.alavruschik_public_subnet.*.id
  security_groups = [
  aws_security_group.alavruschik_sg_vpc_traffic.id,
  aws_security_group.alavruschik_sg_incoming.id
  ]
  idle_timeout = 10
  tags = merge(
    var.tags, 
    map(
    "Name", "alavruschik_alb"
  ))
}

### Standard ###

resource "aws_alb_listener" "alavruschik_alb_https" {
  load_balancer_arn = aws_alb.alavruschik_alb.arn
  port = "443"
  protocol = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.alavruschik_ssl_cert_data.arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Default ALB responce from alavr"
      status_code  = "200"
    }
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.alavruschik_alb.arn
  port = "80"
  default_action {
    type = "redirect"
    redirect {
      status_code = "HTTP_301"
      port        = "443"
      protocol    = "HTTPS"
    }
  }
}

### Nexus ###
resource "aws_alb_target_group" "alavruschik_alb_tg_nexus" {
  name = "alavruschik-alb-tg-nexus"
  port = 8081
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
    "Name", "alavruschik_alb_tg_nexus"
  ))
}

resource "aws_alb_target_group_attachment" "alavruschik_alb_target_group_attachment_nexus" {
  count = length(var.availability_zones)
  target_group_arn = aws_alb_target_group.alavruschik_alb_tg_nexus.arn
  target_id = aws_instance.alavruschik_sonar-qube_nexus.id
  port = 8081
}



resource "aws_lb_listener_rule" "alavruschik_nexus" {
  listener_arn = aws_alb_listener.alavruschik_alb_https.arn
  action {
    type = "forward"
    target_group_arn = aws_alb_target_group.alavruschik_alb_tg_nexus.arn
  }
  condition {
    host_header {
      values = ["nexus.*"]
    }
  }
}

### SonarQube ###

resource "aws_alb_target_group" "alavruschik_alb_tg_sonar-qube" {
  name = "alavruschik-alb-tg-sonar-qube"
  port = 9000
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
    "Name", "alavruschik_alb_target_group_sonar-qube"
  ))
}

resource "aws_alb_target_group_attachment" "alavruschik_alb_target_group_attachment_sonar-qube" {
  count = length(var.availability_zones)
  target_group_arn = aws_alb_target_group.alavruschik_alb_tg_sonar-qube.arn
  target_id = aws_instance.alavruschik_sonar-qube_nexus.id
  port = 9000
}



resource "aws_lb_listener_rule" "alavruschik_sonar-qube" {
  listener_arn = aws_alb_listener.alavruschik_alb_https.arn
  action {
    type = "forward"
    target_group_arn = aws_alb_target_group.alavruschik_alb_tg_sonar-qube.arn
  }
  condition {
    host_header {
      values = ["sonar-qube.*"]
    }
  }
}

### Jenkins ###

resource "aws_alb_target_group" "alavruschik_alb_tg_jenkins" {
  name = "alavruschik-alb-tg-jenkins"
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
    "Name", "alavruschik_alb_target_group_jenkins"
  ))
}

resource "aws_alb_target_group_attachment" "alavruschik_alb_target_group_attachment_jenkins" {
  count = length(var.availability_zones)
  target_group_arn = aws_alb_target_group.alavruschik_alb_tg_jenkins.arn
  target_id = aws_instance.alavruschik_jenkins.id
  port = 8080
}



resource "aws_lb_listener_rule" "alavruschik_jenkins" {
  listener_arn = aws_alb_listener.alavruschik_alb_https.arn
  action {
    type = "forward"
    target_group_arn = aws_alb_target_group.alavruschik_alb_tg_jenkins.arn
  }
  condition {
    host_header {
      values = ["jenkins.*"]
    }
  }
}


### Prometheus ###

resource "aws_alb_target_group" "alavruschik_alb_tg_prometheus" {
  name = "alavruschik-alb-tg-prometheus"
  port = 9090
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
    "Name", "alavruschik_alb_target_group_prometheus"
  ))
}

resource "aws_alb_target_group_attachment" "alavruschik_alb_target_group_attachment_prometheus" {
  count = length(var.availability_zones)
  target_group_arn = aws_alb_target_group.alavruschik_alb_tg_prometheus.arn
  target_id = aws_instance.alavruschik_prometheus_grafana_alertmanager.id
  port = 9090
}



resource "aws_lb_listener_rule" "alavruschik_prometheus" {
  listener_arn = aws_alb_listener.alavruschik_alb_https.arn
  action {
    type = "forward"
    target_group_arn = aws_alb_target_group.alavruschik_alb_tg_prometheus.arn
  }
  condition {
    host_header {
      values = ["prometheus.*"]
    }
  }
}

### Grafana ###

resource "aws_alb_target_group" "alavruschik_alb_tg_grafana" {
  name = "alavruschik-alb-tg-grafana"
  port = 3000
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
    "Name", "alavruschik_alb_target_group_grafana"
  ))
}

resource "aws_alb_target_group_attachment" "alavruschik_alb_target_group_attachment_grafana" {
  count = length(var.availability_zones)
  target_group_arn = aws_alb_target_group.alavruschik_alb_tg_grafana.arn
  target_id = aws_instance.alavruschik_prometheus_grafana_alertmanager.id
  port = 3000
}



resource "aws_lb_listener_rule" "alavruschik_grafana" {
  listener_arn = aws_alb_listener.alavruschik_alb_https.arn
  action {
    type = "forward"
    target_group_arn = aws_alb_target_group.alavruschik_alb_tg_grafana.arn
  }
  condition {
    host_header {
      values = ["grafana.*"]
    }
  }
}

### Alertmanager ###

resource "aws_alb_target_group" "alavruschik_alb_tg_alertmanager" {
  name = "alavruschik-alb-tg-alertmanager"
  port = 9093
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
    "Name", "alavruschik_alb_target_group_alertmanager"
  ))
}

resource "aws_alb_target_group_attachment" "alavruschik_alb_target_group_attachment_alertmanager" {
  count = length(var.availability_zones)
  target_group_arn = aws_alb_target_group.alavruschik_alb_tg_alertmanager.arn
  target_id = aws_instance.alavruschik_prometheus_grafana_alertmanager.id
  port = 9093
}



resource "aws_lb_listener_rule" "alavruschik_alertmanager" {
  listener_arn = aws_alb_listener.alavruschik_alb_https.arn
  action {
    type = "forward"
    target_group_arn = aws_alb_target_group.alavruschik_alb_tg_alertmanager.arn
  }
  condition {
    host_header {
      values = ["alertmanager.*"]
    }
  }
}

