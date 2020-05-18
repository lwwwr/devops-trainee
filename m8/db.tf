resource "aws_db_instance" "alavruschik_rds" {
  identifier = "alavruschik-rds"
  allocated_storage = 20
  max_allocated_storage = 25
  storage_type = "gp2"
  engine = "postgres"
  engine_version = "11.5"
  instance_class = "db.t2.micro"
  port = 5432
  publicly_accessible = false
  backup_retention_period = 7
  maintenance_window = "Mon:03:00-Mon:06:00"
  backup_window = "06:01-06:59"
  apply_immediately = true
  vpc_security_group_ids = [aws_security_group.alavruschik_sg_vpc_traffic.id]
  iam_database_authentication_enabled = false
  db_subnet_group_name = aws_db_subnet_group.alavruschik_rds_subnet_group.id
  final_snapshot_identifier = "alavr-snapshot"
  name = "helloworld"
  username = "helloworld"
  password= "helloworld"
  multi_az = true
  tags = merge(
    var.tags,
    map(
    "Name", "alavruschik_rds"
  ))
}

resource "aws_db_subnet_group" "alavruschik_rds_subnet_group" {
  name = "alavruschik_rds_subnet_group"
  subnet_ids = flatten([aws_subnet.alavruschik_private_db_subnet.*.id])
  tags = merge(
    var.tags,
    map(
    "Name", "alavruschik_rds_subnet_group"
  ))
}