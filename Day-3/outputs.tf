output "ec2-instance-name" {
    value = module.ec2_instance.ec2-instance-name
    description = "EC2 instance Name"
}

output "ec2-instance-id" {
    value = module.ec2_instance.ec2-instance-id
    description = "EC2 instance ID"
}

output "ec2-instance-public-ip-address" {
    value = module.ec2_instance.public-ip-address
    description = "EC2 instance Public IP"
}