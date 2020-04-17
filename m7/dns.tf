resource "aws_route53_zone" "alavruschik_r53_main" {
  name = "alavr.test.coherentprojects.net"
  tags = merge(
    var.tags, 
    map(
    "Name", "alavruschik_r53_main"
  ))
}

resource "aws_route53_record" "alavruschik_r53_parent_ns" {
  zone_id = "Z3W2C0CZ94DL4Z"
  name    = "alavr.test.coherentprojects.net"
  type    = "NS"
  ttl     = "30"

  records = [
    aws_route53_zone.alavruschik_r53_main.name_servers.0,
    aws_route53_zone.alavruschik_r53_main.name_servers.1,
    aws_route53_zone.alavruschik_r53_main.name_servers.2,
    aws_route53_zone.alavruschik_r53_main.name_servers.3,
  ]
}

resource "aws_route53_record" "alavruschik_r53_bastion" {
  zone_id = aws_route53_zone.alavruschik_r53_main.zone_id
  name    = "bastion"
  type    = "A"
  ttl     = "300"

  records = [aws_instance.alavruschik_bastion.public_ip]
}

resource "aws_route53_record" "alavruschik_r53_backend_alb" {
  zone_id = aws_route53_zone.alavruschik_r53_main.zone_id
  name    = "backend-alb"
  type    = "CNAME"
  ttl     = "300"

  records = [aws_alb.alavruschik_backend_alb.dns_name]
}

resource "aws_route53_record" "alavruschik_r53_frontend_alb" {
  zone_id = aws_route53_zone.alavruschik_r53_main.zone_id
  name    = "frontend-alb"
  type    = "CNAME"
  ttl     = "300"

  records = [aws_alb.alavruschik_frontend_alb.dns_name]
}

resource "aws_route53_record" "alavruschik_r53_rds" {
  zone_id = aws_route53_zone.alavruschik_r53_main.zone_id
  name    = "db"
  type    = "CNAME"
  ttl     = "300"

  records = [aws_db_instance.alavruschik_rds.address ]
}