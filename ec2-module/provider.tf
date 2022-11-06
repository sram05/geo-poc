provider "aws" {
  region  = "ap-southeast-1"
}

terraform {
  # specify the exact current version
  required_version = "1.2.9"
  backend "local" {
    path = "terraform.tfstate"
  }
}