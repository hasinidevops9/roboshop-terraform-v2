env           = "dev"
ami_id        = "ami-0eec78ea4cbaaf5bd"
instance_type = "t3.small"

components = {
  frontend = {
    tier = "app"
    ports = {
      ssh  = 22
      http = 80
    }
  }
  catalogue = {
    tier = "app"
    ports = {
      ssh = 22
      app = 8002
    }
  }
  mysql = {
    tier = "db"
    ports = {
      ssh   = 22
      mysql = 3306
    }
  }
}
