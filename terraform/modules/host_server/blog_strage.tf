resource "aws_s3_bucket_policy" "blog_storage" {
  bucket = aws_s3_bucket.blog_storage.id
  policy = data.aws_iam_policy_document.blog_storage.json
}


data "aws_iam_policy_document" "blog_storage" {
  statement {
    sid    = "Allow CloudFront"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.blog_cdn.iam_arn]
    }
    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.blog_storage.arn}/*"
    ]
  }
}

resource "aws_s3_bucket" "blog_storage" {
  bucket_prefix = "${terraform.workspace}-${var.app_name}-blog-storage"
}

resource "aws_s3_bucket_website_configuration" "blog_storage" {
  bucket = aws_s3_bucket.blog_storage.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_acl" "sblog_storage" {
  bucket = aws_s3_bucket.blog_storage.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "blog_storage" {
  bucket = aws_s3_bucket.blog_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}

output "blog_storage_bucket" {
  value = aws_s3_bucket.blog_storage.id
}
