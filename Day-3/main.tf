provider "aws" {
  region = "us-east-1"
}

module "ec2_instance" {
  source = "./modules/ec2_instance"
  ami_value = "ami-0953476d60561c955" # replace this
  instance_type_value = "t2.micro"
  subnet_id_value = "subnet-0d9f444378a9b2e69" # replace this
}