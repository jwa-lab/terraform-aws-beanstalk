resource "aws_acm_certificate" "certificate" {
  domain_name = "${var.domain.sub}.${var.domain.main}"
  subject_alternative_names = [for domain in var.certificate_additional_domains: "${domain.sub}.${domain.main}"]
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

  name = each.value.name
  records = [each.value.record]
  type = each.value.type
  zone_id = data.aws_route53_zone.zones[each.key].id
  ttl = 60
}

resource "aws_acm_certificate_validation" "certificate_validation" {
  certificate_arn = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.certificate_validation_records : record.fqdn]
}
