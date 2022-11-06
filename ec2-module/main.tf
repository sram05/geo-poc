module "ec2" {
  source = ".//ec2"
  ami                    = var.ami
  instance_type          = var.instance_type
  # vpc_id                 = module.vpc.vpc_id
  # subnet_id              = module.vpc.private_subnet_az1
}
