default_vpc_id = "vpc-0477f111f08e9073f"

default_vpc_cidr = "172.31.0.0/16"

default_vpc_route_table_id = "rtb-05eefcb72f97be251"

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

tags = {
  Company_Name  = "Robot Store"
  Business_Unit = "E-Commerce"
  Project_Name  = "RobotShop"
  Cost_Center   = "ecom-rs"
  Create_By     = "Terraform"
}

env = "dev"

alb = {
  public = {
    internal           = false
    load_balancer_type = "application"
    sg_ingress_cidr    = ["0.0.0.0/0"]
    sg_port            = 80
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
    engine_family = 4.0.0
  }
}