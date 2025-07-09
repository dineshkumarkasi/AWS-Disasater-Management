# Primary EC2 Health Check
resource "aws_route53_health_check" "primary_health" {
  fqdn              = "www.dineshprojectsmine.shop"
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = 3
  request_interval  = 30

  tags = {
    Name = "Primary EC2 Health Check"
  }
}

# Primary EC2 Record
resource "aws_route53_record" "primary" {
  zone_id = var.hosted_zone_id
  name    = "www.dineshprojectsmine.shop"
  type    = "A"
  ttl     = 60
  set_identifier = "primary"
  records = [aws_instance.web-primary.public_ip]
  health_check_id = aws_route53_health_check.primary_health.id

  failover_routing_policy {
    type = "PRIMARY"
  }
}

# Secondary EC2 Record
resource "aws_route53_record" "secondary" {
  zone_id = var.hosted_zone_id
  name    = "www.dineshprojectsmine.shop"
  type    = "A"
  ttl     = 60
  set_identifier = "secondary"
  records = [aws_instance.web-secondary.public_ip]

  failover_routing_policy {
    type = "SECONDARY"
  }
}
