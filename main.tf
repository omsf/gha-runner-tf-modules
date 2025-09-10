terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

locals {
  organization = "omsf-eco-infra"
  repos = [
    "gha-runner",
    "dependabot-testing"
  ]
  repo_claims = [for repo in local.repos : "${local.organization}/${repo}:*"]
}

provider "aws" {
  region = "us-east-1"
}

provider "github" {
  owner = split("/", local.organization)[0]
}

module "github_oidc" {
  source = "./modules/github_oidc"
}

module "aws_gha_runner" {
  name_prefix              = "gha-runner-tf"
  source                   = "./modules/aws_gha_runner"
  github_oidc_provider_arn = module.github_oidc.github_oidc_provider_arn
  github_oidc_repos_claims = local.repo_claims
}


resource "github_actions_secret" "secrets" {
  for_each        = toset(local.repos)
  repository      = each.value
  secret_name     = "AWS_ROLE"
  plaintext_value = module.gha_runner.github_actions_oidc_role_arn
}
