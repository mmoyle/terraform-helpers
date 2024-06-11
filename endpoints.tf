# Create VPC Endpoint for Systems Manager
resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = data.aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.ssm"  # Replace with the correct service name for your region
  vpc_endpoint_type = "Interface"
  subnet_ids        = [ data.aws_subnet.selected.id]
  security_group_ids = [aws_security_group.endpoint_sg.id]

  tags = merge( { Name = "ssm" } )
}

resource "aws_vpc_endpoint" "ssm_messages" {
  vpc_id            = data.aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.ssmmessages"  # Replace with the correct service name for your region
  vpc_endpoint_type = "Interface"
  subnet_ids        = [ data.aws_subnet.selected.id]
  security_group_ids = [aws_security_group.endpoint_sg.id]

  tags = merge( { Name = "ssmmessages" } )
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = data.aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.ec2messages"  # Replace with the correct service name for your region
  vpc_endpoint_type = "Interface"
  subnet_ids        = [ data.aws_subnet.selected.id]
  security_group_ids = [aws_security_group.endpoint_sg.id]

  tags = merge( { Name = "ec2messages" } )
}

# Security group for the VPC endpoints
resource "aws_security_group" "endpoint_sg" {
  vpc_id = data.aws_vpc.main.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}