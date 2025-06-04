output "vpc_with_publicsubnets_alb" {
value = {
    vpc_id = aws_vpc.myvpc.id

    public_subnet1_id = aws_subnet.mysubnet1.id
    public_subnet1_az = aws_subnet.mysubnet1.availability_zone

    public_subnet2_id = aws_subnet.mysubnet2.id
    public_subnet2_az = aws_subnet.mysubnet2.availability_zone

    internet_gateway = aws_internet_gateway.myigw.id

    route_table_id = aws_route_table.myrt.id

    security_group = aws_security_group.mysg.id

    s3_bucket_name = aws_s3_bucket.mys3.id

    ec2_instance1_id = aws_instance.myec2-instance1.id
    ec2_instance1_public_ip = aws_instance.myec2-instance1.public_ip
    
    ec2_instance2_id = aws_instance.myec2-instance2.id
    ec2_instance2_public_ip = aws_instance.myec2-instance2.public_ip
 
    appln_load_balancer_id = aws_lb.myalb.id
    appln_load_balancer_dns = aws_lb.myalb.dns_name
    appln_load_balancer_zone_id = aws_lb.myalb.zone_id


    }
}
