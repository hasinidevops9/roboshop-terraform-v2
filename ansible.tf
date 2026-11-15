# Provisioners on the instance run only at create time.
# A null_resource can run again when the trigger values change.
#
# roboshop.yml selects the role using component_name.
# ansible-pull runs the playbook directly on the target instance.

resource "null_resource" "db" {
  for_each = local.db_components

  triggers = {
    instance_id               = aws_instance.main[each.key].id
    private_ip                = aws_instance.main[each.key].private_ip
    dns_name                  = aws_route53_record.main[each.key].fqdn
    ansible_bootstrap_version = "2"
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      host     = aws_instance.main[each.key].public_ip
      user     = var.ssh_user
      password = var.ssh_password
    }

    inline = [
      "sudo dnf install -y python3.14-pip git",
      "sudo python3.14 -m pip install ansible",
      "sudo python3.14 -m ansible.cli.pull -U ${var.ansible_repo} roboshop.yml -e component_name=${each.key}"
    ]
  }
}


# Catalogue depends on MySQL.
# Database provisioning completes before application provisioning starts.
#
# component_name remains frontend or catalogue,
# including when instance_count is increased.

resource "null_resource" "app" {
  depends_on = [null_resource.db]

  for_each = local.app_instances

  triggers = {
    instance_id               = aws_instance.app[each.key].id
    private_ip                = aws_instance.app[each.key].private_ip
    dns_name                  = aws_route53_record.app[each.value.component_name].fqdn
    ansible_bootstrap_version = "2"
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      host     = aws_instance.app[each.key].public_ip
      user     = var.ssh_user
      password = var.ssh_password
    }

    inline = [
      "sudo dnf install -y python3.14-pip git",
      "sudo python3.14 -m pip install ansible",
      "sudo python3.14 -m ansible.cli.pull -U ${var.ansible_repo} roboshop.yml -e component_name=${each.value.component_name}"
    ]
  }
}