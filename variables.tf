variable "oidc_provider_url" {
  type        = string
  description = "URL of the OIDC provider to use for authentication. This should be the URL of the HCP OIDC Provider with your HCP organization ID."
}

variable "aws_iam_role_name" {
  type        = string
  description = "Name of the AWS IAM role to create for HCP Resource Graph access."
  default     = "hcp_resource_graph-role"
}

variable "disabled_permission_sets" {
  type        = set(string)
  description = "AWS resource permissions to remove from the recommended InfraGraph AWS policy."
  default     = []
}
