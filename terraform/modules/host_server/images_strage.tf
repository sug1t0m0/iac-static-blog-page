resource "aws_s3_bucket_policy" "images_strage" {
  bucket = aws_s3_bucket.blog_strage.id
  policy = data.aws_iam_policy_document.images_strage.json
}


data "aws_iam_policy_document" "images_strage" {
  statement {
    sid    = "Allow CloudFront"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.images_cdn.iam_arn]
    }
    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.blog_strage.arn}/*"
    ]
  }
}

resource "aws_s3_bucket" "images_strage" {
  bucket_prefix = "${terraform.workspace}-${var.app_name}-images-strage"
}

resource "aws_s3_bucket_acl" "images_strage" {
  bucket = aws_s3_bucket.images_strage.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "images_strage" {
  bucket = aws_s3_bucket.images_strage.id
  versioning_configuration {
    status = "Enabled"
  }
}
