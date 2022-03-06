locals {
  tag_terraform_value    = "Terraform"
  archive_file_type      = "zip"
  deploy_upload_filename = "lambda_src.zip"
  function_name = "${terraform.workspace}-${var.app_name}-post-change-hook"
}

# CloudWatch Logs
resource "aws_cloudwatch_log_group" "post_change_hook_log_group" {
  name              = "/aws/lambda/${local.function_name}"
  retention_in_days = var.log_retention_in_days
}

resource "aws_lambda_function" "post_change_hook" {
  function_name    = local.function_name
  role             = aws_iam_role.post_change_hook_iam.arn
  handler          = var.lambda_handler 
  runtime          = var.function_runtime 
  memory_size      = var.memory_size
  timeout          = var.timeout
  filename         = data.archive_file.post_change_hook_file.output_path
  source_code_hash = data.archive_file.post_change_hook_file.output_base64sha256

  lifecycle {
    ignore_changes = all
  }
  environment {
    variables = {
      env            = terraform.workspace
    }
  }
}

# Lambda File Zip
data "archive_file" "post_change_hook_file" {
  type        = local.archive_file_type
  source_dir  = var.lambda_source_dir
  output_path = local.deploy_upload_filename
}

resource "aws_lambda_permission" "post_change_hook" {
  statement_id  = "AllowPostsStorageInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.post_change_hook.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${aws_s3_bucket.posts_storage.id}"
}
