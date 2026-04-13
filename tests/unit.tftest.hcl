# Copyright IBM Corp. 2026
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  access_key                  = "mock_access_key"
  region                      = "us-east-1"
  secret_key                  = "mock_secret_key"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_requesting_account_id  = true
}

variables {
  oidc_provider_url = "https://example.com"
}

override_data {
  target          = data.tls_certificate.provider
  override_during = plan

  values = {
    certificates = [
      {
        cert_pem             = "-----BEGIN CERTIFICATE-----\nMIIB\n-----END CERTIFICATE-----"
        is_ca                = false
        issuer               = "CN=app.terraform.io"
        max_path_length      = 0
        not_after            = "2035-01-01T00:00:00Z"
        not_before           = "2025-01-01T00:00:00Z"
        public_key_algorithm = "RSA"
        serial_number        = "01"
        sha1_fingerprint     = "0123456789abcdef0123456789abcdef01234567"
        signature_algorithm  = "SHA256-RSA"
        subject              = "CN=app.terraform.io"
        version              = 3
      },
    ]
    id = "test-certificate-chain"
  }
}

override_resource {
  target          = aws_iam_openid_connect_provider.hcp_infragraph
  override_during = plan

  values = {
    arn = "arn:aws:iam::123456789012:oidc-provider/app.terraform.io"
  }
}

run "default_configuration" {
  command   = plan
  state_key = "default_configuration"

  override_resource {
    target          = aws_iam_role.hcp_infragraph_role
    override_during = plan

    values = {
      arn = "arn:aws:iam::123456789012:role/hcp_infragraph-role"
    }
  }

  assert {
    condition     = output.role_name == "hcp_infragraph-role"
    error_message = "role_name output should default to hcp_infragraph-role"
  }

  assert {
    condition     = output.role_arn == "arn:aws:iam::123456789012:role/hcp_infragraph-role"
    error_message = "role_arn output should expose the planned IAM role ARN"
  }

  assert {
    condition     = aws_iam_policy.hcp_infragraph_resource_access_policy.name == "hcp_infragraph-resource-policy"
    error_message = "resource policy name should trim the trailing -role suffix"
  }

  assert {
    condition     = aws_iam_policy.hcp_infragraph_assumerole_policy.name == "hcp_infragraph-assume-role-policy"
    error_message = "assume-role policy name should trim the trailing -role suffix"
  }

  assert {
    condition     = aws_iam_openid_connect_provider.hcp_infragraph.url == var.oidc_provider_url
    error_message = "OIDC provider URL should come from the module input"
  }

  assert {
    condition     = length(aws_iam_openid_connect_provider.hcp_infragraph.client_id_list) == 1 && one(aws_iam_openid_connect_provider.hcp_infragraph.client_id_list) == "graph.connector.aws"
    error_message = "OIDC provider should keep the default InfraGraph audience"
  }

  assert {
    condition     = length(aws_iam_openid_connect_provider.hcp_infragraph.thumbprint_list) == 1 && one(aws_iam_openid_connect_provider.hcp_infragraph.thumbprint_list) == "0123456789abcdef0123456789abcdef01234567"
    error_message = "OIDC provider should use the thumbprint from the TLS certificate data source"
  }

  assert {
    condition     = sort(tolist(jsondecode(data.aws_iam_policy_document.hcp_infragraph_resource_access_policy.json).Statement[0].Action)) == sort(tolist(jsondecode(file("${path.root}/tests/fixtures/enabled_actions.json"))))
    error_message = "resource access policy actions changed unexpectedly"
  }

  assert {
    condition     = jsondecode(data.aws_iam_policy_document.hcp_infragraph_assumerole_policy.json).Statement[0].Action == "sts:AssumeRoleWithWebIdentity"
    error_message = "assume-role helper policy should grant sts:AssumeRoleWithWebIdentity"
  }

  assert {
    condition     = jsondecode(data.aws_iam_policy_document.hcp_infragraph_assumerole_policy.json).Statement[0].Resource == "*"
    error_message = "assume-role helper policy should target all resources"
  }
}

run "custom_role_name_with_suffix" {
  command   = plan
  state_key = "custom_role_name_with_suffix"

  variables {
    aws_iam_role_name = "my-team-infragraph-role"
  }

  assert {
    condition     = output.role_name == "my-team-infragraph-role"
    error_message = "role_name output should reflect a custom role name"
  }

  assert {
    condition     = aws_iam_policy.hcp_infragraph_resource_access_policy.name == "my-team-infragraph-resource-policy"
    error_message = "resource policy name should trim the custom trailing -role suffix"
  }

  assert {
    condition     = aws_iam_policy.hcp_infragraph_assumerole_policy.name == "my-team-infragraph-assume-role-policy"
    error_message = "assume-role policy name should trim the custom trailing -role suffix"
  }
}

run "custom_role_name_without_suffix" {
  command   = plan
  state_key = "custom_role_name_without_suffix"

  variables {
    aws_iam_role_name = "my-team-infragraph"
  }

  assert {
    condition     = output.role_name == "my-team-infragraph"
    error_message = "role_name output should keep a custom name without -role"
  }

  assert {
    condition     = aws_iam_policy.hcp_infragraph_resource_access_policy.name == "my-team-infragraph-resource-policy"
    error_message = "resource policy name should preserve custom names without -role"
  }

  assert {
    condition     = aws_iam_policy.hcp_infragraph_assumerole_policy.name == "my-team-infragraph-assume-role-policy"
    error_message = "assume-role policy name should preserve custom names without -role"
  }
}
