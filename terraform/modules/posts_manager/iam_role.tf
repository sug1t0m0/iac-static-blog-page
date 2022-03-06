resource "aws_iam_role" "post_change_hook_iam" {
  name = "${terraform.workspace}-${var.app_name}-post-change-hook"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Lambda Policy Data
data "aws_iam_policy_document" "post_change_hook_policy_document" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    effect    = "Allow"
    # TODO
    resources = ["*"]
  }
}


# Lambda Attach Role to Policy
resource "aws_iam_role_policy" "post_change_hook_role_policy" {
  role   = aws_iam_role.post_change_hook_iam.id
  name   = "${terraform.workspace}-${var.app_name}-post-change-hook-policy"
  policy = data.aws_iam_policy_document.post_change_hook_policy_document.json
}
