resource "aws_s3_bucket" "posts_storage" {
  bucket_prefix = "${terraform.workspace}-${var.app_name}-posts-storage"
}

resource "aws_s3_bucket_acl" "posts_storage" {
  bucket = aws_s3_bucket.posts_storage.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "posts_storage" {
  bucket = aws_s3_bucket.posts_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_notification" "aws-lambda-trigger" {
  bucket = aws_s3_bucket.posts_storage.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.post_change_hook.arn
    events              = ["s3:ObjectCreated:*", "s3:ObjectRemoved:*"]
  }
}

output "posts_storage_bucket" {
  value = aws_s3_bucket.posts_storage.id
}
