
resource "aws_vpc" "myvpc" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "amarbvn-tf-vpc"
    }
}

resource "aws_subnet" "mysubnet1" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = var.subnet_cidr1
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags = {
        Name = "amarbvn-tf-subnet1"
    }
}

resource "aws_subnet" "mysubnet2" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = var.subnet_cidr2
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
    tags = {
        Name = "amarbvn-tf-subnet2"
    }
}

resource "aws_internet_gateway" "myigw" {
    vpc_id = aws_vpc.myvpc.id
    tags = {
        Name = "amarbvn-tf-igw"
    }
}

resource "aws_route_table" "myrt" {
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = "0.0.0.0/0"    ##Allows access from anywhere 
        gateway_id = aws_internet_gateway.myigw.id
    }
    tags = {
        Name = "amarbvn-tf-rt"
    }
}

resource "aws_route_table_association" "rta1" {
    subnet_id = aws_subnet.mysubnet1.id
    route_table_id = aws_route_table.myrt.id
}

resource "aws_route_table_association" "rta2" {
    subnet_id = aws_subnet.mysubnet2.id
    route_table_id = aws_route_table.myrt.id
}

resource "aws_security_group" "mysg" {
    name = "amarbvn-tf-sg"
    vpc_id = aws_vpc.myvpc.id
    ingress {
        description = "Allow HTTP traffic"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allow SSH traffic"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "amarbvn-tf-sg"
    }
}

resource "aws_s3_bucket" "mys3" {
    bucket = "amarbvn-tf-s3"
    tags = {
    Name = "amarbvn-tf-s3"
  }
}

resource "aws_instance" "myec2-instance1" {
    ami = "ami-084568db4383264d4"   ## AMI for Ubuntu
    instance_type = "t2.micro"
    subnet_id = aws_subnet.mysubnet1.id
    vpc_security_group_ids = [aws_security_group.mysg.id]
    user_data = base64encode(file("script1.sh"))
    tags = {
        Name = "amarbvn-tf-ec2-instance1"
    }
}
  
resource "aws_instance" "myec2-instance2" {
    ami = "ami-084568db4383264d4"   ## AMI for Ubuntu
    instance_type = "t2.micro"
    subnet_id = aws_subnet.mysubnet2.id
    vpc_security_group_ids = [aws_security_group.mysg.id]
    user_data = base64encode(file("script2.sh"))
    tags = {
        Name = "amarbvn-tf-ec2-instance2"
    }
}

resource "aws_lb" "myalb" {
    name = "amarbvn-tf-alb"
    internal = false        ## Allows access from outside the VP
    load_balancer_type = "application"  ## Application Load Balancer
    security_groups = [aws_security_group.mysg.id]
    subnets = [aws_subnet.mysubnet1.id, aws_subnet.mysubnet2.id]
    tags = {
        Name = "amarbvn-tf-alb"
    } 
}


resource "aws_lb_target_group" "mytg" {
    name = "amarbvn-tf-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.myvpc.id

    health_check {
      path = "/"
      port = "traffic-port"
    }

    tags = {
        Name = "amarbvn-tf-tg"
    }
}


resource "aws_lb_target_group_attachment" "mylbtga1" {
    target_group_arn = aws_lb_target_group.mytg.arn
    target_id = aws_instance.myec2-instance1.id
    port = 80
}

resource "aws_lb_target_group_attachment" "mylbtga2" {
    target_group_arn = aws_lb_target_group.mytg.arn
    target_id = aws_instance.myec2-instance2.id
    port = 80
}

resource "aws_lb_listener" "mylistener" {
    load_balancer_arn = aws_lb.myalb.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.mytg.arn
    }
}


