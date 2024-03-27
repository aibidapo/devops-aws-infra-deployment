resource "random_id" "random" {
  byte_length = 2
}


resource "aws_vpc" "ai-devops-prod" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "ai_devops_prod_vpc-${random_id.random.dec}"

  }
}


resource "aws_internet_gateway" "ai-devops-prod-gw" {
  vpc_id = aws_vpc.ai-devops-prod.id

  tags = {
    Name = "ai-devops-prod-gw-${random_id.random.dec}"
  }
}