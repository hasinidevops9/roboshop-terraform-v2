# A record uses the private IP, same pattern as the Route 53 lesson.
# The name is <component>.<domain> with no -dev suffix.
resource "aws_route53_record" "main" {
  for_each = var.components

  zone_id = var.zone_id
  name    = "${each.key}.${var.domain_name}"
  type    = "A"
  ttl     = var.ttl
  records = [aws_instance.main[each.key].private_ip]
}
