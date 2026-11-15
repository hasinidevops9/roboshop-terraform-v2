# One security group per component. The ports map is different for each one,
# so a dynamic block is used instead of repeating ingress blocks.
resource "aws_security_group" "main" {
  for_each = var.components

  name        = "roboshop-${var.env}-${each.key}"
  description = "${each.key} security group"
  vpc_id      = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = each.value.ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = ingress.key
    }
  }

  # Terraform removes the AWS default outbound rule, so add it back.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = each.key
    Environment = var.env
  }
}
