# Terraform Modules for AWS VPC, EC2, S3 and Route 53

This is a POC for terraform modules to interact with each other  **Terraform Modules for AWS VPC, EC2, S3 and Route 53**.
Below is the list of modules 

## Terraform Modules
1. VPC
2. EC2
3. S3
4. ROUTE53


 

## How to run modules - All
- module "vpc" {
- source                      = "./vpc-module/vpc"
    region                      = var.region
    project_name                = var.project_name
    vpc_cidr                    = var.vpc_cidr
    public_subnet_az1_cidr      = var.public_subnet_az1_cidr
    public_subnet_az2_cidr      = var.public_subnet_az2_cidr
    private_subnet_az1_cidr     = var.private_subnet_az1_cidr
    private_subnet_az2_cidr     = var.private_subnet_az2_cidr

}