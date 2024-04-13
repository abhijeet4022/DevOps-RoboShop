project_name = "roboshop"
default_vpc_id = "vpc-0477f111f08e9073f"
vpc          = {
  roboshop-vpc = {
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

