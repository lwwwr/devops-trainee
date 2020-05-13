resource "aws_instance" "alavruschik_jenkins_ec2" {
  ami = "ami-07ebfd5b3428b6f4d"
  instance_type = "t3.small"
  key_name = var.pem_key
  subnet_id = aws_subnet.alavruschik_public_subnet[0].id
  vpc_security_group_ids = [aws_security_group.alavruschik_sg_incoming.id, aws_security_group.alavruschik_sg_ssh.id, aws_security_group.alavruschik_sg_vpc_traffic.id]
  user_data = file("./scripts/jenkins.sh")
  tags = merge(
    var.tags, map(
    "Name", "alavruschik_jenkins_ec2"
  ))
}

resource "aws_instance" "alavruschik_prometheus_ec2" {
  ami = "ami-07ebfd5b3428b6f4d"
  instance_type = "t3.small"
  key_name = var.pem_key
  subnet_id = aws_subnet.alavruschik_public_subnet[1].id
  vpc_security_group_ids = [aws_security_group.alavruschik_sg_incoming.id, aws_security_group.alavruschik_sg_ssh.id, aws_security_group.alavruschik_sg_vpc_traffic.id]
  user_data = file("./scripts/prometheus.sh")
  tags = merge(
    var.tags, map(
    "Name", "alavruschik_prometheus_ec2"
  ))
}

resource "aws_instance" "alavruschik_grafana_ec2" {
  ami = "ami-07ebfd5b3428b6f4d"
  instance_type = "t3.small"
  key_name = var.pem_key
  subnet_id = aws_subnet.alavruschik_public_subnet[1].id
  vpc_security_group_ids = [aws_security_group.alavruschik_sg_incoming.id, aws_security_group.alavruschik_sg_ssh.id, aws_security_group.alavruschik_sg_vpc_traffic.id]
  user_data = file("./scripts/grafana.sh")
  tags = merge(
    var.tags, map(
    "Name", "alavruschik_grafana_ec2"
  ))
}