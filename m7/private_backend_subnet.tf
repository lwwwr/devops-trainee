resource "aws_subnet" "alavruschik_private_backend_subnet" {
  count = length(var.private_backend_subnet_cidr)
  vpc_id = aws_vpc.alavruschik_vpc_main.id
  cidr_block = element(var.private_backend_subnet_cidr, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = merge(
    var.tags,
    map(
    "Name", "alavruschik_private_backend_subnet-${count.index + 1}"
  ))
}
