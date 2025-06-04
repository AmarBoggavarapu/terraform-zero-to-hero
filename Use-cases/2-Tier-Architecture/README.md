***Here is a complete list of all AWS resources being created by Terraform plan:***

**VPC & Networking**

✅ aws_vpc.myvpc — Virtual Private Cloud

✅ aws_subnet.mysubnet1 — Subnet #1

✅ aws_subnet.mysubnet2 — Subnet #2

✅ aws_internet_gateway.myigw — Internet Gateway

✅ aws_route_table.myrt — Route Table

✅ aws_route_table_association.rta1 — Route Table Association for Subnet 1

✅ aws_route_table_association.rta2 — Route Table Association for Subnet 2


**Compute (EC2)**

✅ aws_instance.myec2-instance1 — EC2 Instance #1

✅ aws_instance.myec2-instance2 — EC2 Instance #2


**Storage**

✅ aws_s3_bucket.mys3 — S3 Bucket


**Security**

✅ aws_security_group.mysg — Security Group


**Load Balancer**

✅ aws_lb.myalb — Application Load Balancer

✅ aws_lb_listener.mylistener — ALB Listener

✅ aws_lb_target_group.mytg — Target Group

✅ aws_lb_target_group_attachment.mylbtga1 — Attach EC2 Instance 1 to Target Group

✅ aws_lb_target_group_attachment.mylbtga2 — Attach EC2 Instance 2 to Target Group

***Total Resources: 16***

