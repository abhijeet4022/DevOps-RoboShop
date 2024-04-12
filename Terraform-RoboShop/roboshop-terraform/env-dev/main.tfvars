project_name = "roboshop"
vpc          = {
  roboshop-vpc = {
    cidr     = "10.0.0.0/16"
    vpc_name = "roboshop-vpc"
    subnets  = {

      public = {
        public1 = { cidr = "10.0.0.0/24", az = us-east-1a }
        public2 = { cidr = "10.0.1.0/24", az = us-east-1b }
      }
      app = {
        app1 = { cidr = "10.0.0.2/24", az = us-east-1a }
        app2 = { cidr = "10.0.0.3/24", az = us-east-1b }
      }
      db = {
        db1 = { cidr = "10.0.0.4/24", az = us-east-1a }
        db2 = { cidr = "10.0.0.5/24", az = us-east-1b }
      }

    }
  }
}

