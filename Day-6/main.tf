provider "aws" {
  region = "us-east-1"
}

variable "ami" {
  description = "Value of AMI for EC2 instance"
}

variable "instance_type" {
  description = "Value of instance type for EC2 instance"
  type = map(string)

  default = {
    "dev" = "t2.micro"
    "stage" = "t2.medium"
    "prod" = "t2.large"
  }
}

variable "subnet_id" {
    description = "Subnet ID for EC2 instance"
}

module "ec2_instance" {
  source = "./modules/ec2_instance"
  ami = var.ami
  instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")
  subnet_id = var.subnet_id
}