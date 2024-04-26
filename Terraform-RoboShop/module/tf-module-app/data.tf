data "aws_ami" "ami" {
  most_recent = true
  name_regex  = "Centos-8-DevOps-Practice"
  owners      = ["973714476881"]
}

# To fetch the private ip of LB
data "dns_a_record_set" "private_alb" {
  host = var.private_alb_name
}