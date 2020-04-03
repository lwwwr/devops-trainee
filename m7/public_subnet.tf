resource "aws_subnet" "alavruschik_public_subnet" {
  count = length(var.public_subnet_cidr)
  vpc_id = aws_vpc.alavruschik_vpc_main.id
  cidr_block = element(var.public_subnet_cidr, count.index)
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = merge(
    var.tags, 
    map(
    "Name", "alavruschik_public_subnet-${count.index + 1}"
  ))
}
