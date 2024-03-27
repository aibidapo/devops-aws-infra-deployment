resource "aws_vpc" "ai-devops-prod" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "ai_devops_prod_vpc"

  }
}