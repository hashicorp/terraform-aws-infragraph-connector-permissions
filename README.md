# Terraform Infragraph AWS Connector Module

This module creates the AWS IAM resources needed for HCP Infragraph to authenticate with AWS through OIDC and read supported AWS resources.

## What This Module Creates

- An `aws_iam_openid_connect_provider` for the HCP Infragraph OIDC issuer
- An `aws_iam_role` trusted by that OIDC provider
- A resource access policy built from the recommended AWS permission sets in `locals.tf`
- An additional policy granting `sts:AssumeRoleWithWebIdentity`
- Policy attachments that attach both policies to the role

## Usage

```hcl
module "infragraph_aws_connector" {
  source = "hashicorp/infragraph-connector-permissions/aws"

  oidc_provider_url = "https://<your-hcp-oidc-provider-url>"
}
```

After `terraform apply`, use the exported `role_arn` or `role_name` when configuring the AWS connector in HCP Infragraph.

## Optional Naming Configuration

You can override `aws_iam_role_name`. The module derives both IAM policy names from that value by trimming a trailing `-role` and appending the policy-specific suffix.

```hcl
module "infragraph_aws_connector" {
  source = "hashicorp/infragraph-connector-permissions/aws"

  oidc_provider_url   = "https://<your-hcp-oidc-provider-url>"
  aws_iam_role_name   = "my-team-infragraph-role"
}
```

This produces:

- IAM role: `my-team-infragraph-role`
- Resource access policy: `my-team-infragraph-resource-policy`
- Assume-role policy: `my-team-infragraph-assume-role-policy`

If `aws_iam_role_name` does not end with `-role`, the full value is used as-is before `-resource-policy` or `-assume-role-policy` is appended.

## Installed AWS Permission Groups

The generated resource access policy includes these permission groups:

- `account`
- `autoscaling`
- `cloudformation`
- `cloudwatch`
- `dynamodb`
- `ec2`
- `ecs`
- `eks`
- `elasticfilesystem`
- `elasticloadbalancing`
- `iam`
- `lambda`
- `rds`
- `route53`
- `s3`
- `secretsmanager`
- `sns`
- `sqs`

## Inputs

- `oidc_provider_url`: Required. HCP OIDC provider URL for your organization.
- `aws_iam_role_name`: Optional. Defaults to `hcp_infragraph-role`. The module derives `aws_iam_resource_access_policy_name` and `aws_iam_assume_role_policy_name` from this value by trimming a trailing `-role` and appending `-resource-policy` and `-assume-role-policy`.

## Outputs

- `role_arn`
- `role_name`

## Where The AWS Permissions Live

The source of truth for the installed AWS resource permissions is `locals.tf`.

- `local.permission_sets` contains the action lists, grouped by AWS service or feature area.
- `local.enabled_actions` flattens those groups into the final action list.
- `local.aws_iam_resource_access_policy_name` and `local.aws_iam_assume_role_policy_name` derive policy names from `aws_iam_role_name`.
- `main.tf` uses those locals to build and attach the AWS policies.

The module also attaches one additional policy from `main.tf` that grants:

- `sts:AssumeRoleWithWebIdentity`

If you need the exact AWS actions this module installs, open `locals.tf` and review `local.permission_sets`.
