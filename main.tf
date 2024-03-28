locals {
  azs = data.aws_availability_zones.available.names
}

locals {
  account_name = "ai-devops-prod"
}

data "aws_availability_zones" "available" {}

resource "random_id" "random" {
  byte_length = 2
}


resource "aws_vpc" "ai_devops_prod" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.account_name}-vpc-${random_id.random.dec}"

  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_internet_gateway" "ai_devops_prod_gw" {
  vpc_id = aws_vpc.ai_devops_prod.id

  tags = {
    Name = "${local.account_name}-gw-${random_id.random.dec}"
  }
}

resource "aws_route_table" "ai_devops_prod_public_rt" {
  vpc_id = aws_vpc.ai_devops_prod.id

  tags = {
    Name = "${local.account_name}-public"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.ai_devops_prod_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ai_devops_prod_gw.id
}

resource "aws_default_route_table" "ai_devops_prod_private_rt" {
  default_route_table_id = aws_vpc.ai_devops_prod.default_route_table_id
  tags = {
    Name = "${local.account_name}-private"
  }
}

resource "aws_subnet" "ai_devops_prod_public_subnet" {
  vpc_id                  = aws_vpc.ai_devops_prod.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone       = local.azs[count.index]

  count = length(local.azs)

  tags = {
    Name = "${local.account_name}-public-${count.index + 1}"
  }
}

resource "aws_subnet" "ai_devops_prod_private_subnet" {
  vpc_id                  = aws_vpc.ai_devops_prod.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, length(local.azs) + count.index)
  map_public_ip_on_launch = false
  availability_zone       = local.azs[count.index]

  count = length(local.azs)

  tags = {
    Name = "${local.account_name}-private-${count.index + 1}"
  }
}

resource "aws_route_table_association" "ai_devops_prod_public_assoc" {
  count          = length(local.azs)
  subnet_id      = aws_subnet.ai_devops_prod_public_subnet[count.index].id
  route_table_id = aws_route_table.ai_devops_prod_public_rt.id
}