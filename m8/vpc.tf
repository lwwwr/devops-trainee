resource "aws_vpc" "alavruschik_vpc_main" {
  cidr_block = var.local_cidr
  tags = merge(
  var.tags,
  map(
    "Name", "alavruschik_vpc_main"
    )
  )
}
