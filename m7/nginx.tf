resource "aws_instance" "alavruschik_nginx_ec2" {
  ami = "ami-07ebfd5b3428b6f4d"
  instance_type = "t2.micro"
  key_name = var.pem_key
  subnet_id = aws_subnet.alavruschik_public_subnet[0].id
  vpc_security_group_ids = [aws_security_group.alavruschik_sg_incoming.id, aws_security_group.alavruschik_sg_ssh.id, aws_security_group.alavruschik_sg_vpc_traffic.id]
  user_data = data.template_file.nginx.rendered
  tags = merge(
    var.tags, map(
    "Name", "alavruschik_nginx_ec2"
  ))
}