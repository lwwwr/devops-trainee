resource "aws_instance" "alavruschik_jenkins" {
  ami = "ami-07ebfd5b3428b6f4d"
  instance_type = "t3.small"
  key_name = var.pem_key
  subnet_id = aws_subnet.alavruschik_private_subnet[1].id
  vpc_security_group_ids = [aws_security_group.alavruschik_sg_vpc_traffic.id] 
  tags = merge(
    var.tags, map(
    "Name", "alavruschik_jenkins"
  ))
}

resource "aws_instance" "alavruschik_sonar-qube_nexus" {
  ami = "ami-07ebfd5b3428b6f4d"
  instance_type = "t3.large"
  key_name = var.pem_key
  subnet_id = aws_subnet.alavruschik_private_subnet[0].id
  vpc_security_group_ids = [aws_security_group.alavruschik_sg_vpc_traffic.id]  
  tags = merge(
    var.tags,
    map(
      "Name", "alavruschik_sonar-qube_nexus"
    )
  )
}

resource "aws_instance" "alavruschik_prometheus_grafana_alertmanager" {
  ami = "ami-07ebfd5b3428b6f4d"
  instance_type = "t3.small"
  key_name = var.pem_key
  subnet_id = aws_subnet.alavruschik_private_subnet[0].id
  vpc_security_group_ids = [aws_security_group.alavruschik_sg_vpc_traffic.id] 
  tags = merge(
    var.tags,
    map(
      "Name", "alavruschik_prometheus_grafana_alertmanager"
    )
  )
}

# resource "aws_instance" "alavruschik_backend" {
#   ami = "ami-07ebfd5b3428b6f4d"
#   instance_type = "t2.medium"
#   key_name = var.pem_key
#   subnet_id = aws_subnet.alavruschik_private_subnet[1].id
#   vpc_security_group_ids = [aws_security_group.alavruschik_sg_vpc_traffic.id] 

#   tags = merge(
#     var.tags, map(
#     "Name", "alavruschik_backend"
#   ))
# }

# resource "aws_instance" "alavruschik_frontend_filebeat" {
#   ami = "ami-07ebfd5b3428b6f4d"
#   instance_type = "t3.small"
#   key_name = var.pem_key
#   subnet_id = aws_subnet.alavruschik_private_subnet[0].id
#   vpc_security_group_ids = [aws_security_group.alavruschik_sg_vpc_traffic.id] 
#   tags = merge(
#     var.tags, map(
#     "Name", "alavruschik_frontend_filebeat"
#   ))
# }

# resource "aws_instance" "alavruschik_logstash_kibana" {
#   ami = "ami-07ebfd5b3428b6f4d"
#   instance_type = "t3.small"
#   key_name = var.pem_key
#   subnet_id = aws_subnet.alavruschik_private_subnet[1].id
#   vpc_security_group_ids = [aws_security_group.alavruschik_sg_vpc_traffic.id] 
#   tags = merge(
#     var.tags, map(
#     "Name", "alavruschik_logstash_kibana"
#   ))
# }

# resource "aws_instance" "alavruschik_all_elastic" {
#   ami = "ami-07ebfd5b3428b6f4d"
#   instance_type = "t3.small"
#   key_name = var.pem_key
#   subnet_id = aws_subnet.alavruschik_private_subnet[0].id
#   vpc_security_group_ids = [aws_security_group.alavruschik_sg_vpc_traffic.id] 
#   tags = merge(
#     var.tags, map(
#     "Name", "alavruschik_all_elastic"
#   ))
# }