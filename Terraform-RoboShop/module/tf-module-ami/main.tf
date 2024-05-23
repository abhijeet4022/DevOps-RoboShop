# tfstate file
terraform {
  backend "s3" {
    bucket = "learntechnology.cloud"
    key    = "ami/terraform.tfstate"
    region = "us-east-1"
  }
}

# Fetch the AMI for instance
data "aws_ami" "ami" {
  most_recent = true
  name_regex  = "Centos-8-DevOps-Practice"
  owners      = ["973714476881"]
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

# Configure the instance
resource "null_resource" "commands" {
  connection {
    type     = "ssh"
    user     = "root"
    password = "DevOps321"
    host     = aws_instance.ami.private_ip
  }
  provisioner "remote-exec" {
    inline = [
      "yum install ansible bash-completion python3.11-pip.noarch -y",
      "pip3.11 install botocore boto3",
    ]
  }
}

# Create AMI from above instance.
resource "aws_ami_from_instance" "ami" {
  depends_on         = [null_resource.commands]
  name               = "roboshop-ami-v1"
  source_instance_id = aws_instance.ami.id
  tags               = { Name = "roboshop-ami-v1" }
}
