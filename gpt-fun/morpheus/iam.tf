data "aws_iam_policy_document" "morpheus_service_role_policy" {

  statement {
    sid    = "AllowECRImageRetrieval"
    effect = "Allow"
    actions = [
      "ecr:ListTagsForResource",
      "ecr:DescribeImages",
      "ecr:ListImages",
      "ecr:DescribeRepositories",
      "ecr:DescribeImages",
      "ecr:GetRepositoryPolicy",
      "ecr:GetLifecyclePolicy"
    ]
    resources = ["arn:aws:ecr:*:*:repository/*"]
  }
}

resource "aws_iam_policy" "morpheus_service_role_policy" {
  name   = "morpheus_service_role_policy"
  policy = data.aws_iam_policy_document.morpheus_service_role_policy.json

  tags = local.default_tags
}


module "iam_eks_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.11"

  role_name = "morpheus-service-role"

  role_policy_arns = {
    policy = aws_iam_policy.morpheus_service_role_policy.arn
  }

  oidc_providers = {
    one = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["${kubernetes_namespace.morpheus.metadata[0].name}:morpheus"]
    }
  }
}

resource "kubernetes_service_account" "morpheus_s3_sync" {
  metadata {
    name      = "morpheus"
    namespace = kubernetes_namespace.morpheus.metadata[0].name
    annotations = {
      "eks.amazonaws.com/role-arn" = module.iam_eks_role.iam_role_arn
    }
  }
}
