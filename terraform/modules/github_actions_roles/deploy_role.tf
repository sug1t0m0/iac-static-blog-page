data "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_role" "deploy_role" {
  name = "deploy-${var.app_name}"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "${data.aws_iam_openid_connect_provider.github_actions.arn}"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringLike" : {
            "token.actions.githubusercontent.com:sub" : "repo:${var.github_owner}/${var.github_repo}:ref:refs/heads/*"
          },
        }
      }
    ]
  })
}

data "aws_iam_policy_document" "deploy" {
  statement {
    actions = [
      "s3:GetObject",
    ]

    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.posts_storage_name}/*"]
  }

  statement {
    actions = [
      "s3:ListBucket",
    ]

    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.posts_storage_name}"]
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.blog_storage_name}/*"]
  }

  statement {
    actions = [
      "s3:ListBucket",
    ]

    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.blog_storage_name}"]
  }

  statement {
    actions = [
      "cloudfront:CreateInvalidation",
    ]

    effect    = "Allow"
    resources = ["arn:aws:cloudfront::${var.account_id}:distribution/${var.distribution_id}"]
  }
}


resource "aws_iam_role_policy" "deproy" {
  name   = "deploy-${var.app_name}"
  role   = aws_iam_role.deploy_role.id
  policy = data.aws_iam_policy_document.deploy.json
}
