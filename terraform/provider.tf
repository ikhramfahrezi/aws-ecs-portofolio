terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Kita pakai region Singapore (ap-southeast-1) karena dekat dan murah
provider "aws" {
  region = "ap-southeast-1" 
}