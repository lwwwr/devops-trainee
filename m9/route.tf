resource "aws_route_table" "alavruschik_route_public" {
  vpc_id = aws_vpc.alavruschik_vpc_main.id
  route {
    cidr_block = var.global_cidr  
    gateway_id = aws_internet_gateway.alavruschik_internet_gateway.id
  }
  tags = merge(
    var.tags,
    map(
    "Name", "alavruschik_route_public"
  ))
}

resource "aws_route_table" "alavruschik_route_private" {
  count = length(var.private_backend_subnet_cidr)
  vpc_id = aws_vpc.alavruschik_vpc_main.id
  route {
    cidr_block = var.global_cidr  
    instance_id = element(aws_instance.alavruschik_nat_ec2.*.id, count.index)
  }
  tags = merge(
    var.tags,
    map(
    "Name", "alavruschik_route_private"
  ))
}

resource "aws_route_table_association" "alavruschik_route_assosiation_public" {
  count = length(var.public_subnet_cidr)
  subnet_id = element(aws_subnet.alavruschik_public_subnet.*.id, count.index)
  route_table_id = aws_route_table.alavruschik_route_public.id
}

resource "aws_route_table_association" "alavruschik_route_assosiation_private" {
  count = length(var.private_backend_subnet_cidr)
  subnet_id = element(aws_subnet.alavruschik_private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.alavruschik_route_private.*.id, count.index)
}

# resource "aws_route_table_association" "alavruschik_route_assosiation_private_db" {
#   count          = length(var.private_db_subnet_cidr)
#   subnet_id      = element(aws_subnet.alavruschik_private_db_subnet.*.id, count.index)
#   route_table_id = aws_route_table.alavruschik_route_private.id
# }