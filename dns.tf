resource "aws_route53_record" "platform_api_domain_record" {
  name = "${local.sub_domain}.${local.domain_name}"
  type = "A"
  zone_id = data.aws_route53_zone.api_domain_route53_zone.id

  alias {
    evaluate_target_health = false
    name = aws_elastic_beanstalk_environment.beanstalk_env.cname
    zone_id = data.aws_elastic_beanstalk_hosted_zone.current.id
  }
}
