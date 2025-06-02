provider "aws" {
  region = "us-east-1"
}

provider "vault" {
  address = "http://54.89.99.162:8200" ## Public IP address of EC2 instance: Port (8200 used in creating vault configuration)
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "XXXXXXXXXXXXXX" ## Role ID created in vault integration setup
      secret_id = "XXXXXXXXXXXXXX" ## Secret ID created in vault integration setup.
      ## secret_id is often one-time use unless configured otherwise.
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "kv" // change it according to your mount
  name  = "test-secret" // change it according to your secret
}


resource "aws_instance" "my_instance" {
  ami           = "ami-084568db4383264d4"   ## Update accordingly as per your machine
  instance_type = "t2.micro"
  subnet_id = "subnet-0d9f444378a9b2e69"

  tags = {
    Name = "test-ec2-instance"
    Secret = data.vault_kv_secret_v2.example.data["username"]
  }
}

