data "aws_route53_zone" "api_domain_route53_zone" {
  name = local.domain_name
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_elastic_beanstalk_hosted_zone" "current" {}
