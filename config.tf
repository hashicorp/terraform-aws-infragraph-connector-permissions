# Copyright IBM Corp. 2026
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "~>4"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~>6"
    }
  }
}

