variable "name_prefix" {
  type        = string
  description = "The name of the prefix for the resources"
  default     = "gha-runner"
}

variable "enable_tagging_permission" {
  type        = bool
  description = "Enable tagging permission"
  default     = false
}

variable "github_oidc_repos_claims" {
  type        = list(string)
  description = "The claims for the OIDC provider"
}

variable "github_oidc_provider_arn" {
  type        = string
  description = "The ARN of the OIDC provider"
}
