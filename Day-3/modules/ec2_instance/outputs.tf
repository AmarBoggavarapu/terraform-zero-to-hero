output "ec2-instance-name" {
    value = aws_instance.example.tags["Name"]
}

output "ec2-instance-id" {
    value = aws_instance.example.id
}

output "public-ip-address" {
    value = aws_instance.example.public_ip
}