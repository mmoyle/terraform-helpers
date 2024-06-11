# Data source for the existing VPC
data "aws_vpc" "main" {
  id = var.vpc_id
}

#get subnets for vpc
data "aws_subnets" "vpc" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}