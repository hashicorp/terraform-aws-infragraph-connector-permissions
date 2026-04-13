variable "oidc_provider_url" {
  type        = string
  description = "URL of the OIDC provider to use for authentication. This should be the URL of the HCP OIDC Provider with your HCP organization ID."
}

variable "aws_iam_role_name" {
  type        = string
  description = "Name of the AWS IAM role to create for HCP InfraGraph access. Related policy names are derived from this by trimming a trailing -role suffix."
  default     = "hcp_infragraph-role"
}
