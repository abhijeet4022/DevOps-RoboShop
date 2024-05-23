data "aws_ami" "ami" {
  most_recent = true
  name_regex  = "roboshop-ami-v1"
  owners      = ["767398040211"]
}
# Fetch the SG id
data "aws_security_group" "sg" {
  name = "allow-all"
}

# Instance Creation
resource "aws_instance" "ami" {
  ami                    = data.aws_ami.ami.id
  instance_type          = "t3.small"
  vpc_security_group_ids = [data.aws_security_group.sg.id]
  tags                   = { Name = "ami" }
}
