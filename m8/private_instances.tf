#https://github.com/dmeiners88/sonarqube-prometheus-exporter
resource "aws_instance" "alavruschik_private_sonar-qube_ec2" {
  ami = "ami-07ebfd5b3428b6f4d"
  instance_type = "c5.xlarge"
  key_name = var.pem_key
  subnet_id = aws_subnet.alavruschik_private_subnet.*.id[0]
  vpc_security_group_ids = [aws_security_group.alavruschik_sg_vpc_traffic.id]  
  # user_data = file("./scripts/sonar-cube.sh")
  tags = merge(
    var.tags,
    map(
      "Name", "alavruschik_private_sonar-qube_ec2"
    )
  )
}

# https://github.com/nviallatte/nexus-prometheus-exporter
# https://github.com/ocadotechnology/nexus-exporter
# docker run -p 9184:9184 -e NEXUS_HOST='http://host' -e NEXUS_USERNAME=admin -e NEXUS_ADMIN_PASSWORD='password'  ocadotechnology/nexus-exporter

resource "aws_instance" "alavruschik_private_nexus_ec2" {
  ami = "ami-07ebfd5b3428b6f4d"
  instance_type = "c5.xlarge"
  key_name = var.pem_key
  subnet_id = aws_subnet.alavruschik_private_subnet.*.id[1]
  vpc_security_group_ids = [aws_security_group.alavruschik_sg_vpc_traffic.id] 
  # user_data = file("./scripts/nexus.sh")
  tags = merge(
    var.tags,
    map(
      "Name", "alavruschik_private_nexus_ec2"
    )
  )
}
