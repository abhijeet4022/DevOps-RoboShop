data "aws_ami" "ami" {
  most_recent = true
  name_regex  = "roboshop-ami-v1"
  owners      = ["767398040211"]
}

# Fetch the SG id
data "aws_security_group" "sg" {
  name = "allow-all"
}

resource "aws_instance" "main" {
  ami                    = data.aws_ami.ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_security_group.sg.id]
  tags                   = { Name = "test" }
}