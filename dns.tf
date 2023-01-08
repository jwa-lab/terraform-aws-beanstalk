resource "aws_route53_record" "main_domain" {
  name = "${var.domain.sub}.${var.domain.main}"
  type = "A"
  zone_id = data.aws_route53_zone.zones["${var.domain.sub}.${var.domain.main}"].id

  alias {
    evaluate_target_health = false
    name = aws_elastic_beanstalk_environment.beanstalk_env.cname
    zone_id = data.aws_elastic_beanstalk_hosted_zone.current.id
  }
}
