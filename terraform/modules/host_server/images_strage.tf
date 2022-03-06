resource "aws_s3_bucket_policy" "images_storage" {
  bucket = aws_s3_bucket.images_storage.id
  policy = data.aws_iam_policy_document.images_storage.json
}


data "aws_iam_policy_document" "images_storage" {
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
      "${aws_s3_bucket.images_storage.arn}/*"
    ]
  }
}

resource "aws_s3_bucket" "images_storage" {
  bucket_prefix = "${terraform.workspace}-${var.app_name}-images-storage"
}

resource "aws_s3_bucket_acl" "images_storage" {
  bucket = aws_s3_bucket.images_storage.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "images_storage" {
  bucket = aws_s3_bucket.images_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}
