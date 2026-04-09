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
  source = "git::https://github.com/hashicorp/terraform-infragraph-aws-connector-module.git"

  oidc_provider_url = "https://<your-hcp-oidc-provider-url>"
}
```

After `terraform apply`, use the exported `role_arn` or `role_name` when configuring the AWS connector in HCP Infragraph.

## Optional Configuration

You can keep the default policy set, or remove specific permission groups with `disabled_permission_sets`.

```hcl
module "infragraph_aws_connector" {
  source = "git::https://github.com/hashicorp/terraform-infragraph-aws-connector-module.git"

  oidc_provider_url = "https://<your-hcp-oidc-provider-url>"

  disabled_permission_sets = [
    "iam",
    "s3",
  ]
}
```

Available permission-set names:

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
- `aws_iam_role_name`: Optional. Defaults to `hcp_infragraph-role`.
- `aws_iam_resource_access_policy_name`: Optional. Defaults to `hcp_infragraph-resource-policy`.
- `aws_iam_assume_role_policy_name`: Optional. Defaults to `hcp_infragraph-assume-role-policy`.
- `disabled_permission_sets`: Optional set of permission-set names to exclude from the generated resource access policy.

## Outputs

- `role_arn`
- `role_name`

## Where The AWS Permissions Live

The source of truth for the installed AWS resource permissions is `locals.tf`.

- `local.permission_sets` contains the action lists, grouped by AWS service or feature area.
- `local.enabled_actions` flattens those groups into the final action list, excluding anything named in `disabled_permission_sets`.
- `main.tf` uses that action list to build and attach the AWS resource access policy.

The module also attaches one additional policy from `main.tf` that grants:

- `sts:AssumeRoleWithWebIdentity`

If you need the exact AWS actions this module installs, open `locals.tf` and review `local.permission_sets`.
