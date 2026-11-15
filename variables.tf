# Values for these variables come from env-dev/*.auto.tfvars.
# Terraform does not auto-load .auto.tfvars files that sit in a subdirectory.

variable "env" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

# each.key is the component name used by Ansible (frontend, catalogue, mysql).
# tier is "db" or "app", so the database can be provisioned first.
# ports feeds the security group dynamic block.
# instance_count, lb_internal, and health_path are for application components.
# MySQL does not use them: it stays one instance with no load balancer.
variable "components" {
  type = map(object({
    tier           = string
    ports          = map(number)
    instance_count = optional(number, 1)
    lb_internal    = optional(bool, false)
    health_path    = optional(string, "/")
  }))

  validation {
    condition = alltrue([
      for component in var.components :
      component.tier != "app" || component.instance_count >= 1
    ])
    error_message = "Application instance_count must be at least 1."
  }
}

variable "zone_id" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "ttl" {
  type = number
}

# Login for the DevOps Practice AMI. Same values documented in the Ansible repo.
variable "ssh_user" {
  type    = string
  default = "ec2-user"
}

variable "ssh_password" {
  type    = string
  default = "DevOps321"
}

variable "ansible_repo" {
  type    = string
  default = "https://github.com/hasinidevops9/roboshop-ansible.git"
}
