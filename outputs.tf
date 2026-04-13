# Copyright IBM Corp. 2026
# SPDX-License-Identifier: MPL-2.0

output "role_arn" {
  value = aws_iam_role.hcp_infragraph_role.arn
}

output "role_name" {
  value = aws_iam_role.hcp_infragraph_role.name
}
