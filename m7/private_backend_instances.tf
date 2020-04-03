resource "aws_instance" "alavruschik_private_backend_ec2" {
  count = length(var.private_backend_subnet_cidr)
  ami = "ami-07ebfd5b3428b6f4d"
  instance_type = "t2.medium"
  key_name = var.pem_key
  subnet_id = element(aws_subnet.alavruschik_private_backend_subnet.*.id, count.index)
  vpc_security_group_ids = [aws_security_group.alavruschik_sg_vpc_traffic.id]  
  user_data = file("./scripts/tomcat.sh")
  tags = merge(
    var.tags,
    map(
      "Name", "alavruschik_private_backend_ec2-${count.index + 1}"
    )
  )
}

# http://169.254.169.254/latest/dynamic/instance-identity/document
# sudo update-java-alternatives --set /usr/lib/jvm/java-1.8.0-openjdk-amd64