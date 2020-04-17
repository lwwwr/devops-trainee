resource "aws_launch_configuration" "alavruschik_backend_launch_configuration" {
  name = "alavruschik_backend_launch_configuration"
  image_id = "ami-07ebfd5b3428b6f4d"
  instance_type = "t2.medium"
  security_groups = [aws_security_group.alavruschik_sg_vpc_traffic.id]
  #security_groups = [aws_security_group.alavruschik_sg_alb_instances.id]
  key_name = var.pem_key
  user_data = "${base64encode(file("./scripts/backend.sh"))}"
  lifecycle {
    create_before_destroy = true
  }
  # tags = merge(
  #   var.tags,
  #   map(
  #   "Name", "alavruschik_launch_configuration"
  # ))
}

resource "aws_launch_configuration" "alavruschik_frontend_launch_configuration" {
  name = "alavruschik_frontend_launch_configuration"
  image_id = "ami-07ebfd5b3428b6f4d"
  instance_type = "t2.medium"
  security_groups = [aws_security_group.alavruschik_sg_vpc_traffic.id, aws_security_group.alavruschik_sg_incoming.id]
  user_data = "${base64encode(file("./scripts/frontend.sh"))}"
  key_name = var.pem_key

  lifecycle {
    create_before_destroy = true
  }
  # tags = merge(
  #   var.tags,
  #   map(
  #   "Name", "alavruschik_launch_configuration"
  # ))
}