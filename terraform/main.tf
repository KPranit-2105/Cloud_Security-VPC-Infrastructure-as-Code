# Terraform Network Segmentation & Security Controls
# Organization: Apex Cloud Financial Systems (ApexPay)
# Standard Mapping: PCI-DSS v4.0 Requirement 1.2 / 1.3, NIST SP 800-53 AC-4

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "apexpay-production-vpc"
    Environment = "Production"
    Compliance  = "PCI-DSS-CDE"
  }
}

# Public Subnets (ALB & WAF Only)
resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

# Private Application Subnets
resource "aws_subnet" "private_app_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-east-1a"
}

# Isolated Database Subnets (Cardholder Data Environment - CDE)
resource "aws_subnet" "isolated_db_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "us-east-1a"
}

# Strict Database Security Group (Inbound from App Tier ONLY, NO Public Internet)
resource "aws_security_group" "db_sg" {
  name        = "apexpay-isolated-db-sg"
  description = "Strict DB ingress from App tier only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow Postgres 5432 from App Subnets"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    cidr_blocks     = ["10.0.10.0/24"]
  }

  egress {
    description = "Deny all outbound traffic to internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"] # Internal VPC range only
  }
}
