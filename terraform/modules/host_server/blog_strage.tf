resource "aws_s3_bucket_policy" "blog_strage" {
  bucket = aws_s3_bucket.blog_strage.id
  policy = data.aws_iam_policy_document.blog_strage.json
}


data "aws_iam_policy_document" "blog_strage" {
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
      "${aws_s3_bucket.blog_strage.arn}/*"
    ]
  }
}

resource "aws_s3_bucket" "blog_strage" {
  bucket_prefix = "${terraform.workspace}-${var.app_name}-blog-strage"
}

resource "aws_s3_bucket_website_configuration" "blog_strage" {
  bucket = aws_s3_bucket.blog_strage.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_acl" "sblog_strage" {
  bucket = aws_s3_bucket.blog_strage.id
  acl = "private"
}

resource "aws_s3_bucket_versioning" "blog_strage" {
  bucket = aws_s3_bucket.blog_strage.id
  versioning_configuration {
    status = "Enabled"
  }
}
