# Provisioners on the instance run only at create time.
# A null_resource can run again when the trigger values change.
#
# roboshop.yml selects the role with component_name.
# ansible-pull runs that playbook on the instance itself.

resource "null_resource" "db" {
  for_each = local.db_components

  triggers = {
    instance_id = aws_instance.main[each.key].id
    private_ip  = aws_instance.main[each.key].private_ip
    dns_name    = aws_route53_record.main[each.key].fqdn
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      host     = aws_instance.main[each.key].public_ip
      user     = var.ssh_user
      password = var.ssh_password
    }

    inline = [
      "sudo dnf install ansible git -y",
      "ansible-pull -U ${var.ansible_repo} roboshop.yml -e component_name=${each.key}"
    ]
  }
}

# Catalogue loads its schema from mysql.hdevops09.online, so the database
# play must finish before the application plays start.
resource "null_resource" "app" {
  depends_on = [null_resource.db]
  for_each   = local.app_components

  triggers = {
    instance_id = aws_instance.main[each.key].id
    private_ip  = aws_instance.main[each.key].private_ip
    dns_name    = aws_route53_record.main[each.key].fqdn
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      host     = aws_instance.main[each.key].public_ip
      user     = var.ssh_user
      password = var.ssh_password
    }

    inline = [
      "sudo dnf install ansible git -y",
      "ansible-pull -U ${var.ansible_repo} roboshop.yml -e component_name=${each.key}"
    ]
  }
}
