data "aws_ami" "ami" {
  most_recent = true
  name_regex  = "roboshop-ami-v1"
  owners      = ["767398040211"]
}

# To fetch the private ip of LB
data "dns_a_record_set" "private_alb" {
  host = var.private_alb_name
}