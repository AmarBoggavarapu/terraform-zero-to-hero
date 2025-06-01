output "aws_vpc_name" {
    value = aws_vpc.vpc.name
}

output "aws_vpc_id" {
    value = aws_vpc.vpc.id
}

output "aws_subnet_id" {
    value = aws_subnet.subnet.id
}

output "aws_subnet_name" {
    value = aws_subnet.subnet.name
}

output "aws_igw_id" {
    value = aws_internet_gateway.igw.id
}

output "aws_igw_arn" {
    value = aws_internet_gateway.igw.arn
}

output "aws_ec2_instance" {
    value = aws_instance.ec2_instance.public_ip
}
  
