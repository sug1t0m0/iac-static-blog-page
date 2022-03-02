resource "aws_cloudfront_distribution" "blog_cdn" {

  aliases = [local.blog_domain]
  origin {
    domain_name = aws_s3_bucket.blog_strage.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.blog_strage.id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.blog_cdn.cloudfront_access_identity_path
    }
  }

  enabled = true

  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.blog_strage.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["JP"]
    }
  }
  #viewer_certificate {
  #  acm_certificate_arn      = aws_acm_certificate.public.arn
  #  ssl_support_method       = "sni-only"
  #  minimum_protocol_version = "TLSv1"
  #}
}

resource "aws_cloudfront_origin_access_identity" "blog_cdn" {
  comment = local.blog_domain
}
