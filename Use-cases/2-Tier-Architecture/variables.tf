variable "vpc_cidr" {
    description = "CIDR Block VPC address"
    default = "10.0.0.0/16"
}

variable "subnet_cidr1" {
    description = "CIDR Block subnet1 address"
    default = "10.0.1.0/24"
}
  
variable "subnet_cidr2" {
    description = "CIDR Block subnet2 address"
    default = "10.0.2.0/24"
}
