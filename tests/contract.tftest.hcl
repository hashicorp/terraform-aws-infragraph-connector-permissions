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

run "rejects_non_https_oidc_provider_url" {
  command = plan

  variables {
    oidc_provider_url = "http://example.com"
  }

  expect_failures = [
    var.oidc_provider_url,
  ]
}

run "rejects_role_names_with_spaces" {
  command = plan

  variables {
    aws_iam_role_name = "invalid role name"
    oidc_provider_url = "https://example.com"
  }

  expect_failures = [
    var.aws_iam_role_name,
  ]
}

run "rejects_role_names_longer_than_sixty_four_characters" {
  command = plan

  variables {
    aws_iam_role_name = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    oidc_provider_url = "https://example.com"
  }

  expect_failures = [
    var.aws_iam_role_name,
  ]
}
