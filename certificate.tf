resource "aws_acm_certificate" "certificate" {
  domain_name = "${local.sub_domain}.${local.domain_name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "certificate_validation_records" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name = dvo.resource_record_name
      record = dvo.resource_record_value
      type = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name = each.value.name
  records = [each.value.record]
  type = each.value.type
  zone_id = data.aws_route53_zone.api_domain_route53_zone.id
  ttl = 60
}

resource "aws_acm_certificate_validation" "certificate_validation" {
  certificate_arn = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.certificate_validation_records : record.fqdn]
}
