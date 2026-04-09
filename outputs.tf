output "role_arn" {
  value = aws_iam_role.hcp_resource_graph_role.arn
}

output "role_name" {
  value = aws_iam_role.hcp_resource_graph_role.name
}
