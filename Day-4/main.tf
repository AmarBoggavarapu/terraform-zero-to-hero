provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "abhishek" {
  instance_type = "t2.micro"
  ami = "ami-0953476d60561c955" # change this
  subnet_id = "subnet-0d9f444378a9b2e69" # change this
  tags = {
        Name="amarbvn-test-ec2-instance"
    }
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "amarbvn-remote-backend-s3" # change this
  tags = {
        Name = "remote-backend-s3"
    }
}

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"  # String
  }
}