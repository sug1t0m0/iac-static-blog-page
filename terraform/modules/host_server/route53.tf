resource "aws_route53_zone" "public" {
  name = local.blog_domain
}

output "name_servers" {
  description = "A list of name servers in associated (or default) delegation set."
  value       = aws_route53_zone.public.name_servers
}

resource "aws_route53_record" "public_dns_verify" {
  for_each = {
    for dvo in aws_acm_certificate.public.domain_validation_options : dvo.domain_name => {
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
  zone_id         = aws_route53_zone.public.id
}

resource "aws_route53_record" "blog" {
  zone_id = aws_route53_zone.public.id
  name    = local.blog_domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.blog_cdn.domain_name
    zone_id                = aws_cloudfront_distribution.blog_cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "images" {
  zone_id = aws_route53_zone.public.id
  name    = local.images_domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.images_cdn.domain_name
    zone_id                = aws_cloudfront_distribution.images_cdn.hosted_zone_id
    evaluate_target_health = false
  }
}
