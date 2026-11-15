locals {
  # One default subnet for this lab. sort() keeps the choice stable between plans.
  subnet_id = sort(data.aws_subnets.default.ids)[0]

  db_components = {
    for name, component in var.components : name => component if component.tier == "db"
  }

  app_components = {
    for name, component in var.components : name => component if component.tier == "app"
  }
}
