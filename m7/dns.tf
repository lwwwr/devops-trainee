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

resource "aws_route53_record" "alavruschik_r53_nginx" {
  zone_id = aws_route53_zone.alavruschik_r53_main.zone_id
  name    = "nginx"
  type    = "A"
  ttl     = "300"

  records = [aws_instance.alavruschik_nginx_ec2.public_ip]
}

resource "aws_route53_record" "alavruschik_r53_alb" {
  zone_id = aws_route53_zone.alavruschik_r53_main.zone_id
  name    = "alb"
  type    = "CNAME"
  ttl     = "300"

  records = [aws_alb.alavruschik_alb.dns_name]
}