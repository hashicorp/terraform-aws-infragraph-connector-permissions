# Copyright IBM Corp. 2026
# SPDX-License-Identifier: MPL-2.0

variable "oidc_provider_url" {
  type        = string
  description = "URL of the OIDC provider to use for authentication. This should be the URL of the HCP OIDC Provider with your HCP organization ID."

  validation {
    condition     = can(regex("^https://[^\\s]+$", var.oidc_provider_url))
    error_message = "oidc_provider_url must be a valid HTTPS URL."
  }
}

variable "aws_iam_role_name" {
  type        = string
  description = "Name of the AWS IAM role to create for HCP InfraGraph access. Related policy names are derived from this by trimming a trailing -role suffix."
  default     = "hcp_infragraph-role"

  validation {
    condition     = length(var.aws_iam_role_name) > 0 && length(var.aws_iam_role_name) <= 64 && can(regex("^[A-Za-z0-9+=,.@_-]+$", var.aws_iam_role_name))
    error_message = "aws_iam_role_name must be 1-64 characters and use only letters, numbers, and the IAM-supported characters +=,.@_-"
  }
}
