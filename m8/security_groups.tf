resource "aws_security_group" "alavruschik_sg_ssh" {
  name = "alavruschik_sg_ssh"
  vpc_id = aws_vpc.alavruschik_vpc_main.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.global_cidr]
  }
  tags = merge(
    var.tags,
    map(
      "Name", "alavruschik_sg_ssh"
    )
  )
}

resource "aws_security_group" "alavruschik_sg_vpc_traffic" {
  name = "alavruschik_sg_vpc_traffic"
  vpc_id = aws_vpc.alavruschik_vpc_main.id
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.local_cidr]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.global_cidr]
  }

  tags = merge(
    var.tags,
    map(
      "Name", "alavruschik_sg_vpc_traffic"
    )
  )
}

resource "aws_security_group" "alavruschik_sg_incoming" {
  name = "alavruschik_sg_incoming"
  vpc_id      = aws_vpc.alavruschik_vpc_main.id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [var.global_cidr]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "udp"
    cidr_blocks = [var.global_cidr]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [var.global_cidr]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "udp"
    cidr_blocks = [var.global_cidr]
  }
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = [var.global_cidr]
  }
  tags = merge(
    var.tags,
    map(
      "Name", "alavruschik_sg_incoming"
    )
  )
}
