default_vpc_id             = "vpc-0477f111f08e9073f"
default_vpc_cidr           = "172.31.0.0/16"
default_vpc_route_table_id = "rtb-05eefcb72f97be251"
ssh_subnets_cidr           = ["172.31.81.2/32"]
env                        = "dev"
zone_id                    = "Z09678453PONOT92KJ2ZM"
internet_ingress_cidr      = ["0.0.0.0/0"]
monitoring_ingress_cidr    = ["172.31.23.101/32"]

tags = {
  Company_Name  = "Robot Store"
  Business_Unit = "E-Commerce"
  Project_Name  = "RobotShop"
  Cost_Center   = "ecom-rs"
  Create_By     = "Terraform"
}

az                  = ["us-east-1a", "us-east-1b"]
acm_certificate_arn = "arn:aws:acm:us-east-1:767398040211:certificate/77326df3-1d93-43f0-a09c-86baf6cdca63"

vpc = {
  main = {
    cidr     = "10.0.0.0/16"
    vpc_name = "roboshop-vpc"
    subnets  = {

      public = {
        public1 = { cidr = "10.0.0.0/24", az = "us-east-1a" }
        public2 = { cidr = "10.0.1.0/24", az = "us-east-1b" }
      }
      app = {
        app1 = { cidr = "10.0.2.0/24", az = "us-east-1a" }
        app2 = { cidr = "10.0.3.0/24", az = "us-east-1b" }
      }
      db = {
        db1 = { cidr = "10.0.4.0/24", az = "us-east-1a" }
        db2 = { cidr = "10.0.5.0/24", az = "us-east-1b" }
      }

    }
  }
}

alb = {
  public = {
    internal           = false
    load_balancer_type = "application"
    sg_ingress_cidr    = ["0.0.0.0/0"]
    sg_port            = 443
  }
  private = {
    internal           = true
    load_balancer_type = "application"
    # App subnet resource will talk to each other by LB so need to allow the app subnet and default vpc cidr.
    sg_ingress_cidr    = ["172.31.0.0/16", "10.0.0.0/16"]
    sg_port            = 80
  }
}

docdb = {
  main = {
    engine_family           = "docdb4.0"
    backup_retention_period = 5
    preferred_backup_window = "07:00-09:00"
    skip_final_snapshot     = true
    engine_version          = "4.0.0"
    instance_count          = 2
    instance_class          = "db.t3.medium"

  }
}

rds = {
  main = {
    family                  = "mysql5.6"
    sg_port                 = 3306
    rds_type                = "aurora-mysql"
    engine                  = "aurora-mysql"
    engine_version          = "5.7.mysql_aurora.2.11.4"
    backup_retention_period = 5
    preferred_backup_window = "07:00-09:00"
    skip_final_snapshot     = true
    instance_count          = 2
    instance_class          = "db.t3.small"
  }
}

elasticache = {
  main = {
    skip_final_snapshot = true
    elasticache_type    = "redis"
    engine              = "redis"
    engine_version      = "6.2"
    family              = "redis6.x"
    node_type           = "cache.t3.micro"
    num_cache_nodes     = 1
    sg_port             = 6379
  }
}

rabbitmq = {
  main = {
    instance_type = "t3.small"
    sg_port       = "5672"

  }
}

app = {
  frontend = {
    sg_port          = 80
    instance_type    = "t3.small"
    desired_capacity = 1 # Desired cannot be less then min size
    max_size         = 3
    min_size         = 1
    priority         = 1
    parameters       = ["nexus"]
    # Nexus role is required to fetch the parameter by app instance to fetch the artifact from nexus.
    tags             = { Monitor_Nginx = "yes" }
  }
  catalogue = {
    sg_port          = 8080
    instance_type    = "t3.small"
    desired_capacity = 1
    max_size         = 3
    min_size         = 1
    priority         = 2
    parameters       = ["docdb", "nexus"]
    tags             = {}
  }
  user = {
    sg_port          = 8080
    instance_type    = "t3.small"
    desired_capacity = 1
    max_size         = 3
    min_size         = 1
    priority         = 3
    parameters       = ["docdb", "nexus"]
    # User component required docdb endpoint also. So to access docdb parameter for ssm we are passing docdb as well. And for redis parameter it will take care by var.component in local of app module because redis host name is user.dev.* so by component name we can access it.
    tags             = {}
  }
  cart = {
    sg_port          = 8080
    instance_type    = "t3.small"
    desired_capacity = 1
    max_size         = 3
    min_size         = 1
    priority         = 4
    parameters       = ["nexus"]
    tags             = {}
  }
  shipping = {
    sg_port          = 8080
    instance_type    = "t3.small"
    desired_capacity = 1
    max_size         = 3
    min_size         = 1
    priority         = 5
    parameters       = ["rds", "nexus"]
    tags             = {}
  }
  payment = {
    sg_port          = 8080
    instance_type    = "t3.small"
    desired_capacity = 1
    max_size         = 3
    min_size         = 1
    priority         = 6
    parameters       = ["rabbitmq", "nexus"]
    tags             = {}
  }
  dispatch = {
    sg_port          = 8080
    instance_type    = "t3.small"
    desired_capacity = 1
    max_size         = 3
    min_size         = 1
    priority         = 7
    parameters       = ["rabbitmq", "nexus"]
    tags             = {}
  }
}

prometheus = {
  prometheus = {
    from_port     = 0
    to_port       = 65535
    instance_type = "t3.small"
  }
}