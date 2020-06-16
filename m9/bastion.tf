resource "aws_instance" "alavruschik_bastion" {
  ami = "ami-07ebfd5b3428b6f4d"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id  = element(aws_subnet.alavruschik_public_subnet.*.id, 0)
  key_name = var.pem_key
  vpc_security_group_ids = [aws_security_group.alavruschik_sg_ssh.id, aws_security_group.alavruschik_sg_vpc_traffic.id]

  tags = merge(
    var.tags,
    map(
      "Name", "alavruschik_bastion_us-east-1",
    )
  )
}