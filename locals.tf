# Copyright IBM Corp. 2026
# SPDX-License-Identifier: MPL-2.0

locals {
  aws_iam_resource_access_policy_name = "${trimsuffix(var.aws_iam_role_name, "-role")}-resource-policy"
  aws_iam_assume_role_policy_name     = "${trimsuffix(var.aws_iam_role_name, "-role")}-assume-role-policy"

  permission_sets = {
    account = [
      "account:GetAccountInformation",
    ]
    cloudformation = [
      "cloudformation:GetResource",
      "cloudformation:ListResources",
    ]
    cloudwatch = [
      "logs:DescribeLogGroups",
      "logs:ListTagsForResource",
      "cloudwatch:DescribeAlarms",
      "events:ListRules",
      "events:DescribeRule",
      "events:ListTagsForResource",
      "events:ListTargetsByRule",
    ]
    ec2 = [
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeImages",
      "ec2:DescribeInstances",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeRegions",
      "ec2:DescribeRouteTables",
      "ec2:DescribeSecurityGroupRules",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVolumes",
      "ec2:DescribeVpcs",
    ]
    ecs = [
      "ecs:DescribeClusters",
      "ecs:DescribeServices",
      "ecs:ListClusters",
      "ecs:ListServices",
      "ecs:DescribeCapacityProviders",
    ]
    iam = [
      "iam:GetPolicyVersion",
      "iam:ListAttachedRolePolicies",
      "iam:ListPolicies",
      "iam:ListRoles",
      "iam:ListUsers",
    ]
    lambda = [
      "lambda:ListFunctions",
      "lambda:GetPolicy",
    ]
    rds = [
      "rds:DescribeDBClusters",
      "rds:DescribeDBInstances",
    ]
    s3 = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketPublicAccessBlock",
    ]
    sqs = [
      "sqs:ListQueues",
      "sqs:GetQueueAttributes",
    ]
    eks = [
      "eks:ListClusters",
      "eks:DescribeCluster",
    ]
    sns = [
      "sns:ListTopics",
      "sns:GetTopicAttributes",
      "sns:ListSubscriptions",
      "sns:GetSubscriptionAttributes",
    ]
    route53 = [
      "route53:GetHostedZone",
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
      "route53:ListTagsForResource",
      "route53:ListQueryLoggingConfigs",
    ]
    secretsmanager = [
      "secretsmanager:ListSecrets",
      "secretsmanager:GetResourcePolicy",
    ]
    dynamodb = [
      "dynamodb:ListTables",
      "dynamodb:DescribeTable",
    ]
    autoscaling = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeLifecycleHooks",
      "autoscaling:DescribeNotificationConfigurations",
    ]
    elasticfilesystem = [
      "elasticfilesystem:DescribeFileSystems",
      "elasticfilesystem:DescribeFileSystemPolicy",
      "elasticfilesystem:DescribeBackupPolicy",
      "elasticfilesystem:DescribeLifecycleConfiguration",
      "elasticfilesystem:DescribeReplicationConfigurations",
      "elasticfilesystem:DescribeMountTargets",
      "elasticfilesystem:DescribeMountTargetSecurityGroups",
    ]
    elasticloadbalancing = [
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
    ]
  }

  enabled_actions = distinct(flatten([
    for permission_set_name in sort(keys(local.permission_sets)) : local.permission_sets[permission_set_name]
  ]))
}
