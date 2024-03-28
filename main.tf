data "aws_availability_zones" "available" {}

resource "random_id" "random" {
  byte_length = 2
}


resource "aws_vpc" "ai_devops_prod" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "ai_devops_prod_vpc-${random_id.random.dec}"

  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_internet_gateway" "ai_devops_prod_gw" {
  vpc_id = aws_vpc.ai_devops_prod.id

  tags = {
    Name = "ai-devops-prod-gw-${random_id.random.dec}"
  }
}

resource "aws_route_table" "ai_devops_prod_public_rt" {
  vpc_id = aws_vpc.ai_devops_prod.id

  tags = {
    Name = "ai-devops-prod-public"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.ai_devops_prod_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ai_devops_prod_gw.id
}

resource "aws_default_route_table" "ai_devops_private_rt" {
  default_route_table_id = aws_vpc.ai_devops_prod.default_route_table_id
  tags = {
    Name = "ai-devops-prod-private"
  }
}

resource "aws_subnet" "ai_devops_public_subnet" {
  vpc_id                  = aws_vpc.ai_devops_prod.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  count = length(var.public_cidrs)

  tags = {
    Name = "ai-devops-prod-public-${count.index + 1}"
  }
}