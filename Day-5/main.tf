variable "cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

resource "aws_key_pair" "keypair" {
    key_name = "amarbvn-demo-keypair"
    public_key = file("~/.ssh/id_rsa.pub")
}
  
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  tags = {
    Name = "amarbvn-demo-vpc"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "amarbvn-demo-subnet"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "amarbvn-demo-igw"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = "amarbvn-demo-route-table"
  }
}

resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_security_group" "security_group" {
  name        = "amarbvn-demo-security-group"
  description = "Security group for amarbvn-demo"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "amarbvn-demo-security-group"
  }
}

resource "aws_instance" "ec2" {
  ami           = "ami-0c55b159cbfafe1f0"     ## AMI to be updated accordingly
  instance_type = "t2.micro"
  key_name = aws_key_pair.keypair.id
  subnet_id     = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.security_group.id]
  associate_public_ip_address = true
  tags = {
    Name = "amarbvn-demo-ec2"
  }

connection {
  type = "ssh"
  user = "ubuntu"
  private_key = file("~/.ssh/id_rsa")
  host = self
}

## File provisioner to a copy a file to remote EC2 instance.
provisioner "file" {
  source      = "app.py"
  destination = "/home/ubuntu/app.py"
}

## Remote Exec Provisioner to run a command on EC2 instance
provisioner "remote-exec" {
  inline = [
    "echo 'Hello from remote EC2 instance'",
    "sudo apt update -y",
    "sudo apt-get install python3-pip -y",
    
    "cd /home/ubuntu",
    "sudo pip3 install flask",
    "sudo nohup python3 /home/ubuntu/app.py > /dev/null 2>&1 &"
  ]
}

}
