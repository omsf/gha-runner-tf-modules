# aws_gha_runner module

This Terraform module creates the necessary configuration on AWS to deploy `start-aws-gha-runner` and `stop-aws-gha-runner`.
It creates the necessary role for deploying self-hosted runners on AWS.

## Features
---
- Creates and IAM policy
- Creates and IAM role
- Assigns the IAM policy to the role

## Usage
---
```hcl

module "aws_gha_runner" {
  source                   = "github.com/omsf/gha-runner-modules//modules/aws_gha-runner"
  # Prefix to be used in AWS
  name_prefix              = "gha-runner-tf"
  # The ARN for the GitHub OIDC Provider
  github_oidc_provider_arn = module.github_oidc.github_oidc_provider_arn

  # A list of OIDC claims
  github_oidc_repos_claims = ["owner/repo:*"]
}
```

## Inputs
| Name | Type | Description | Default | Required |
|------|------|-------------|---------|----------|
| `name_prefix` | `string` | The name of the prefix for the resources | `gha-runner` | No |
| `enable_tagging_permission` | `bool` | Enable tagging permission | `false` | No |
| `github_oidc_repos_claims` | `list(string)` | Claims for the OIDC provider | | Yes |
| `github_oidc_provider_arn` | `string` | ARN of the OIDC provider | | Yes |

## Outputs
| Name                     | Description               |
|--------------------------|---------------------------|
| `github_actions_oidc_role_arn` | ARN of the GitHub Actions role |

## Requirements
| Name | Version |
|------|---------|
| terraform | >=1 |
| aws | ~> 4.0 |
