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
  allow_overwrite = true
  
  records = [
    aws_route53_zone.alavruschik_r53_main.name_servers.0,
    aws_route53_zone.alavruschik_r53_main.name_servers.1,
    aws_route53_zone.alavruschik_r53_main.name_servers.2,
    aws_route53_zone.alavruschik_r53_main.name_servers.3,
  ]
}


resource "aws_route53_record" "alavruschik_alias-alb" {
  zone_id = aws_route53_zone.alavruschik_r53_main.zone_id
  name    = "alavr.test.coherentprojects.net."
  type    = "A"
  alias {
    evaluate_target_health = false
    name                   = aws_alb.alavruschik_alb.dns_name
    zone_id                = aws_alb.alavruschik_alb.zone_id
  }
}

resource "aws_route53_record" "alavruschik_r53_all" {
  zone_id = aws_route53_zone.alavruschik_r53_main.zone_id
  name    = "*"
  type    = "CNAME"
  ttl     = "60"

  records = ["alavr.test.coherentprojects.net"]
}

resource "aws_route53_record" "alavruschik_r53_bastion" {
  zone_id = aws_route53_zone.alavruschik_r53_main.zone_id
  name    = "bastion"
  type    = "A"
  ttl     = "60"

  records = [aws_instance.alavruschik_bastion.public_ip]
}



# resource "aws_route53_record" "alavruschik_r53_rds" {
#   zone_id = aws_route53_zone.alavruschik_r53_main.zone_id
#   name    = "db"
#   type    = "CNAME"
#   ttl     = "300"

#   records = [aws_db_instance.alavruschik_rds.address ]
# }