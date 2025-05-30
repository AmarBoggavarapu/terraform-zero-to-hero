terraform {
  backend "s3" {
    bucket         = "amarbvn-remote-backend-s3" # change this
    key            = "amarbvn//terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}