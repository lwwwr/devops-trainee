resource "aws_instance" "alavruschik_nat_ec2" {
  count = length(var.public_subnet_cidr)
  ami = "ami-06633932c6ba1188a"
  instance_type = "t2.nano"
  subnet_id = element(aws_subnet.alavruschik_public_subnet.*.id, count.index)
  key_name = var.pem_key
  vpc_security_group_ids = [aws_security_group.alavruschik_sg_incoming.id, aws_security_group.alavruschik_sg_vpc_traffic.id]
  source_dest_check = "false"

  tags = merge(
    var.tags,
    map(
      "Name", "alavruschik_nat_ec2-${count.index + 1}"
    )
  )
}