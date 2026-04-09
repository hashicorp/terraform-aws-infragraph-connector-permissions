output "role_arn" {
  value = aws_iam_role.hcp_infragraph_role.arn
}

output "role_name" {
  value = aws_iam_role.hcp_infragraph_role.name
}
