resource "aws_internet_gateway" "alavruschik_internet_gateway" {
  vpc_id = aws_vpc.alavruschik_vpc_main.id
  tags = merge(
    var.tags, 
    map(
    "Name", "alavruschik_internet_gateway"
  ))
}