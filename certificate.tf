/* resource "aws_acm_certificate" "cert" {
  domain_name               = local.site_domain
  subject_alternative_names = ["*.${local.site_domain}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
} */

/* resource "aws_route53_record" "dns_records" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.hosted_zone.zone_id
} */

/* resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.dns_records : record.fqdn]
} */

/* resource "aws_lb_listener" "example" {
  # ... other configuration ...

  certificate_arn = aws_acm_certificate_validation.cert_validation.certificate_arn
} */

/* resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = [
    "${aws_route53_record.cert_validation_record_root.fqdn}",
    "${aws_route53_record.cert_validation_record_wildcard.fqdn}",
  ]
} */

/* # For the root domain
resource "aws_route53_record" "cert_validation_record_root" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = aws_acm_certificate.cert.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options.0.resource_record_type
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

# For all the child domains (wildcard)
resource "aws_route53_record" "cert_validation_record_wildcard" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = aws_acm_certificate.cert.domain_validation_options.1.resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options.1.resource_record_type
  records = ["${aws_acm_certificate.cert.domain_validation_options.1.resource_record_value}"]
  ttl     = 60
} */
