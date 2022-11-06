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
        keys(module.ec2.private_ip)[0]
      ]
    },
  ]

  depends_on = [module.zones,
                module.ec2]
}


