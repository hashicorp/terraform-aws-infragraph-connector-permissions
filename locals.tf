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
      "ec2:DescribeNetworkAcls",
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
      "s3:GetAccelerateConfiguration",
      "s3:GetAnalyticsConfiguration",
      "s3:GetBucketAbac",
      "s3:GetBucketCORS",
      "s3:GetBucketLogging",
      "s3:GetBucketMetadataTableConfiguration",
      "s3:GetBucketNotification",
      "s3:GetBucketObjectLockConfiguration",
      "s3:GetBucketOwnershipControls",
      "s3:GetBucketTagging",
      "s3:GetBucketVersioning",
      "s3:GetBucketWebsite",
      "s3:GetEncryptionConfiguration",
      "s3:GetIntelligentTieringConfiguration",
      "s3:GetInventoryConfiguration",
      "s3:GetLifecycleConfiguration",
      "s3:GetMetricsConfiguration",
      "s3:GetReplicationConfiguration",
      "s3:ListBucket",
      "s3:ListTagsForResource",
    ]
    sqs = [
      "sqs:ListQueues",
      "sqs:GetQueueAttributes",
      "sqs:ListQueueTags",
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
      "sns:GetDataProtectionPolicy",
      "sns:ListSubscriptionsByTopic",
      "sns:ListTagsForResource",
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
      "dynamodb:DescribeContinuousBackups",
      "dynamodb:DescribeContributorInsights",
      "dynamodb:DescribeKinesisStreamingDestination",
      "dynamodb:DescribeTimeToLive",
      "dynamodb:GetResourcePolicy",
      "dynamodb:ListTagsOfResource",
    ]
    autoscaling = [
      "autoscaling:Describe*",
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
      "elasticloadbalancing:DescribeCapacityReservation",
      "elasticloadbalancing:DescribeTags",
    ]
    managed-fleets = [
      "managed-fleets:Get*",
    ]
  }

  enabled_actions = distinct(flatten([
    for permission_set_name in sort(keys(local.permission_sets)) : local.permission_sets[permission_set_name]
  ]))
}
