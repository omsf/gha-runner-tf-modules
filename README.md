# gha-runner-tf-modules
This repository contains Terraform/OpenTofu modules to easily setup needed steps on AWS and GitHub for [`gha-runner`](https://github.com/omsf/gha-runner).

Both modules are located under the modules folder. 
You have one for configuring `gha-runner` on AWS and one for setting up GitHub's OIDC provider on AWS.
We split these out to ensure that users can use this for other use-cases other than the one we are using here.

## Example

```hcl
locals {
  organization = "<your GitHub organization name>"
  repos = [
    "<your-first-repo-name>",
    "<your-second-repo-name>"
    # etc.
  ]
  # This sets up the same repo claims for all of your repos listed above
  repo_claims = [for repo in local.repos : "${local.organization}/${repo}:*"]
}

provider "aws" {
  region = "us-east-1"
}

provider "github" {
  owner = local.organization
}

# This sets up your OIDC on AWS
module "github_oidc" {
  source                   = "github.com/omsf/gha-runner-tf-modules//modules/github_oidc"
}

# This configures your policy on AWS to handle this
module "aws_gha_runner" {
  source                   = "github.com/omsf/gha-runner-tf-modules//modules/aws_gha_runner"
  name_prefix              = "gha-runner-tf"
  github_oidc_provider_arn = module.github_oidc.github_oidc_provider_arn
  github_oidc_repos_claims = local.repo_claims
}


# This will add your AWS Role to your GitHub repos as a secret
resource "github_actions_secret" "secrets" {
  for_each        = toset(local.repos)
  repository      = each.value
  secret_name     = "AWS_ROLE"
  plaintext_value = module.gha_runner.github_actions_oidc_role_arn
}
```
