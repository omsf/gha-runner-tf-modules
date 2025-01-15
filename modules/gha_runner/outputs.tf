output "github_actions_oidc_role_arn" {
  value       = aws_iam_role.gha_runner_oidc_role.arn
  description = "ARN of the GitHub Actions role"
}
