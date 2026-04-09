data "tls_certificate" "provider" {
  url = "https://app.terraform.io"
}

resource "aws_iam_role" "hcp_resource_graph_role" {
  name               = var.aws_iam_role_name
  assume_role_policy = data.aws_iam_policy_document.hcp_resource_graph_oidc_assume_role_policy.json
}

resource "aws_iam_openid_connect_provider" "hcp_resource_graph" {
  url = var.oidc_provider_url

  client_id_list = [
    "graph.connector.aws", # Default audience in HCP resource graph for AWS.
  ]

  thumbprint_list = [
    data.tls_certificate.provider.certificates[0].sha1_fingerprint,
  ]
}


data "aws_iam_policy_document" "hcp_resource_graph_oidc_assume_role_policy" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.hcp_resource_graph.arn]
    }
  }
}

data "aws_iam_policy_document" "hcp_resource_graph_resource_access_policy" {
  statement {
    effect    = "Allow"
    actions   = local.enabled_actions
    resources = ["*"]
  }
}

resource "aws_iam_policy" "hcp_resource_graph_resource_access_policy" {
  name        = var.aws_iam_resource_access_policy_name
  description = "A policy that allows the resource graph to access resources"
  policy      = data.aws_iam_policy_document.hcp_resource_graph_resource_access_policy.json
}

resource "aws_iam_role_policy_attachment" "hcp_resource_graph_access_resources_policy_attachment" {
  role       = aws_iam_role.hcp_resource_graph_role.name
  policy_arn = aws_iam_policy.hcp_resource_graph_resource_access_policy.arn
}

data "aws_iam_policy_document" "hcp_resource_graph_assumerole_policy" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRoleWithWebIdentity"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "hcp_resource_graph_assumerole_policy" {
  name        = var.aws_iam_assume_role_policy_name
  description = "A policy that allows the resource graph to call sts:AssumeRoleWithWebIdentity"
  policy      = data.aws_iam_policy_document.hcp_resource_graph_assumerole_policy.json
}

resource "aws_iam_role_policy_attachment" "hcp_resource_graph_assume_policy_attachment" {
  role       = aws_iam_role.hcp_resource_graph_role.name
  policy_arn = aws_iam_policy.hcp_resource_graph_assumerole_policy.arn
}

