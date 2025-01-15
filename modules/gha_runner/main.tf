resource "aws_iam_policy" "gha_runner_policy" {
  name        = "${var.name_prefix}-policy"
  description = "Policy for the GitHub Actions runner"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = concat(
          [
            "ec2:RunInstances",
            "ec2:TerminateInstances",
            "ec2:DescribeInstances",
            "ec2:DescribeInstanceStatus",
            "ec2:DescribeImages",
          ],
          var.enable_tagging_permission ? ["ec2:CreateTags"] : []
        )
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "gha_runner_oidc_role" {
  name = "${var.name_prefix}-oidc-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = var.github_oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com",
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = [
              for pattern in var.github_oidc_repos_claims : "repo:${pattern}"
            ]
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "gha_runner_policy_attachment" {
  policy_arn = aws_iam_policy.gha_runner_policy.arn
  role       = aws_iam_role.gha_runner_oidc_role.name
}
