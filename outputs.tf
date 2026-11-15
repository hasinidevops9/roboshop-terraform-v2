output "instance_ids" {
  value = { for name, instance in aws_instance.main : name => instance.id }
}

output "private_ips" {
  value = { for name, instance in aws_instance.main : name => instance.private_ip }
}

output "public_ips" {
  value = { for name, instance in aws_instance.main : name => instance.public_ip }
}

output "dns_records" {
  value = { for name, record in aws_route53_record.main : name => record.fqdn }
}

output "vpc_id" {
  value = data.aws_vpc.default.id
}

output "environment" {
  value = var.env
}
