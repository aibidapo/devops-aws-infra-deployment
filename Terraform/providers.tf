terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.42.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  #   shared_credentials_files = "/home/ansible/.aws/credentials"
  # profile = "iamadmin-prod"

}