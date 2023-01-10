data "aws_route53_zone" "zones" {
  for_each = {
    for domain in concat([var.domain], var.additional_domains) : "${domain.sub}.${domain.main}" => {
      name: domain.main
    }
  }

  name = each.value.name
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    visibility = "public"
  }
}

data "aws_subnets" "private_apps" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    visibility = "private"
    target = "apps"
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_elastic_beanstalk_hosted_zone" "current" {}

data "aws_elb_service_account" "current" {}
