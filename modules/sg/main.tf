resource "aws_security_group" "EatonALB-SG" {
  description = "Allow WEB access trough common ports on the ALB"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Ingress HTTP"
    from_port   = "80"
    protocol    = "tcp"
    self        = "false"
    to_port     = "80"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Ingress HTTPS"
    from_port   = "443"
    protocol    = "tcp"
    self        = "false"
    to_port     = "443"
  }

  name = "EatonALB-SG"

  tags = {
    Name = "EatonALB-SG"
    Used = "ALB - Web Access - Internet Faced"
  }

  vpc_id = var.vpc_id
}

resource "aws_security_group" "EatonProducers-SG" {
  description = "Allow Producer to Serve Connections"

  egress {
    cidr_blocks     = ["0.0.0.0/0"]
    from_port       = "0"
    protocol        = "-1"
    self            = "false"
    to_port         = "0"
  }

  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }


  name = "EatonProducers-SG"

  tags = {
    Name = "EatonProducers-SG"
    Used = "EC2 Producers"
  }

  vpc_id = var.vpc_id
}

output "EatonProducers-SG-id" {
  description = "ID of the security group"
  value       = try(aws_security_group.EatonProducers-SG.id, null)
}

resource "aws_security_group" "EatonConsumers-SG" {
  description = "Allow Consumers to Serve Connections"

  egress {
    cidr_blocks     = ["0.0.0.0/0"]
    from_port       = "0"
    protocol        = "-1"
    self            = "false"
    to_port         = "0"
  }

  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }


  name = "EatonConsumers-SG"

  tags = {
    Name = "EatonConsumers-SG"
    Used = "EC2 Consumers"
  }

  vpc_id = var.vpc_id
}

output "EatonConsumers-SG-id" {
  description = "ID of the security group"
  value       = try(aws_security_group.EatonConsumers-SG.id, null)
}

resource "aws_security_group" "RabbitMQ-SG" {
  description = "Allows RabbitMQ Access - Default Ports"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "RabbitMQ UI Port"
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    description = "RabbitMQ All Ports Internally"
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }


  name = "RabbitMQ-SG"

  tags = {
    Name = "RabbitMQ-SG"
    Used = "Allows RabbitMQ Access - Default Ports"
  }

    vpc_id = var.vpc_id
}

output "RabbitMQ-SG-id" {
  description = "ID of the security group"
  value       = try(aws_security_group.RabbitMQ-SG.id, null)
}

resource "aws_security_group" "CommonServicePort-3000-SG" {
  description = "CommonServicePort-3000-SG"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = "3000"
    protocol    = "tcp"
    self        = "false"
    to_port     = "3000"
  }

  tags = {
    Name = "CommonServicePort-3000-SG"
    Used = "Allow services ECS to serve port 3000"
  }

  name   = "CommonServicePort-3000-SG"

  vpc_id = var.vpc_id
}

resource "aws_security_group" "CommonServicePort-3030-SG" {
  description = "CommonServicePort-3000-SG"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = "3030"
    protocol    = "tcp"
    self        = "false"
    to_port     = "3030"
  }

  tags = {
    Name = "CommonServicePort-3030-SG"
    Used = "Allow services ECS to serve port 3030"
  }

  name   = "CommonServicePort-3030-SG"

  vpc_id = var.vpc_id
}


resource "aws_security_group" "uS-WS-Connectivity-SG" {
  description = "Security Group for Panel Connectivity service on Fargate"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "tcp"
    self        = "false"
    to_port     = "65535"
  }

  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = "3000"
    protocol    = "tcp"
    self        = "false"
    to_port     = "3000"
  }

  name   = "uS-WS-Connectivity-SG"

    tags = {
    Name = "uS-WS-Connectivity-SG"
    Used = "Allow services ECS to serve port 300 for uS Connectivity"
  }

  vpc_id = var.vpc_id
}

resource "aws_security_group" "EatonSecureConnect-rds-SG" {
  name_prefix = "EatonSecureConnect-rds"
  description = "Allow Mysql inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Mysql Port"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
}

output "EatonSecureConnect-rds-SG-id" {
  description = "ID of the security group"
  value       = aws_security_group.EatonSecureConnect-rds-SG.id
}
