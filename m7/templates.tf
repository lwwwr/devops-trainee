data template_file nginx {
  template = "${file("${path.module}/scripts/nginx.sh")}"
  vars = {
    tomcat_ips = join(" ", aws_instance.alavruschik_private_backend_ec2.*.private_ip)
  }
}