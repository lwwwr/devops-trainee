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

resource "aws_route53_record" "alavruschik_r53_jenkins" {
  zone_id = aws_route53_zone.alavruschik_r53_main.zone_id
  name    = "jenkins"
  type    = "A"
  ttl     = "300"

  records = [aws_instance.alavruschik_jenkins_ec2.public_ip]
}

resource "aws_route53_record" "alavruschik_r53_prometheus" {
  zone_id = aws_route53_zone.alavruschik_r53_main.zone_id
  name    = "prometheus"
  type    = "A"
  ttl     = "300"

  records = [aws_instance.alavruschik_prometheus_ec2.public_ip]
}

resource "aws_route53_record" "alavruschik_r53_grafana" {
  zone_id = aws_route53_zone.alavruschik_r53_main.zone_id
  name    = "grafana"
  type    = "A"
  ttl     = "300"

  records = [aws_instance.alavruschik_grafana_ec2.public_ip]
}

resource "aws_route53_record" "alavruschik_r53_nexus_alb" {
  zone_id = aws_route53_zone.alavruschik_r53_main.zone_id
  name    = "nexus"
  type    = "CNAME"
  ttl     = "300"

  records = [aws_alb.alavruschik_nexus_alb.dns_name]
}

resource "aws_route53_record" "alavruschik_r53_sonar-qube_alb" {
  zone_id = aws_route53_zone.alavruschik_r53_main.zone_id
  name    = "sonar-qube"
  type    = "CNAME"
  ttl     = "300"

  records = [aws_alb.alavruschik_sonar-qube_alb.dns_name]
}

resource "aws_route53_record" "alavruschik_r53_rds" {
  zone_id = aws_route53_zone.alavruschik_r53_main.zone_id
  name    = "db"
  type    = "CNAME"
  ttl     = "300"

  records = [aws_db_instance.alavruschik_rds.address ]
}

# resource "aws_route53_record" "alavruschik_r53_sonar-cube" {
#   zone_id = aws_route53_zone.alavruschik_r53_main.zone_id
#   name    = "sonar-cube"
#   type    = "A"
#   ttl     = "300"

#   records = [aws_instance.alavruschik_private_sonar-qube_ec2.private_ip]
# }

# resource "aws_route53_record" "alavruschik_r53_nexus" {
#   zone_id = aws_route53_zone.alavruschik_r53_main.zone_id
#   name    = "nexux"
#   type    = "A"
#   ttl     = "300"

#   records = [aws_instance.alavruschik_private_nexus_ec2.private_ip]
# }
