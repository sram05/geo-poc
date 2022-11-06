# Terraform Modules for AWS VPC, EC2, S3 and Route 53

This is a POC for terraform modules to interact with each other  **Terraform Modules for AWS VPC, EC2, S3 and Route 53**.
Below is the list of modules 

## Terraform Modules
1. VPC
2. EC2
3. S3
4. ROUTE53


 

## How to run modules - All

=============================================================================
module "vpc" {
    source                      = "./vpc-module/vpc"
    region                      = var.region
    project_name                = var.project_name
    vpc_cidr                    = var.vpc_cidr
    public_subnet_az1_cidr      = var.public_subnet_az1_cidr
    public_subnet_az2_cidr      = var.public_subnet_az2_cidr
    private_subnet_az1_cidr     = var.private_subnet_az1_cidr
    private_subnet_az2_cidr     = var.private_subnet_az2_cidr
}

===============================================================================

module "ec2" {
  source = "./ec2-module/ec2"
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id = module.vpc.private_subnet_az1_id
  project_name  =var.project_name
  vpc_id  = module.vpc.vpc_id
  depends_on = [module.vpc]
}
=========================================================================
module "zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 2.0"

  zones = {
     "geo-terraform-test.com" = {
      comment = "geo-terraform-test.com (poc)"
      tags = {
        env = "poc"
      }
    }

  }

  tags = {
    ManagedBy = "Terraform"
  }
}

==============================================================================

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = keys(module.zones.route53_zone_zone_id)[0]

  records = [
    {
      name    = "instance-test"
      type    = "A"
      ttl     = 3600
      records = [
            module.ec2.private_ip
      ]
    },
  ]

  depends_on = [module.zones,
                module.ec2]
}
