# Only the components in var.components are created.
# This project does not manage the existing workstation instance.
resource "aws_instance" "main" {
  for_each = var.components

  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = local.subnet_id
  vpc_security_group_ids      = [aws_security_group.main[each.key].id]
  associate_public_ip_address = true

  tags = {
    Name        = each.key
    Environment = var.env
  }
}
