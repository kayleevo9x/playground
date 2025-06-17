# AWS Secrets Manager secrets for API keys
resource "aws_secretsmanager_secret" "ghsa_api_key" {
    name        = "ghsa-api-key"
    description = "GitHub Security Advisory API Key"

    tags = local.default_tags
}

resource "aws_secretsmanager_secret" "nvd_api_key" {
    name        = "nvd-api-key"
    description = "National Vulnerability Database API Key"

    tags = local.default_tags
}

resource "aws_secretsmanager_secret" "nvidia_api_key" {
    name        = "nvidia-api-key"
    description = "NVIDIA API Key"

    tags = local.default_tags
}

resource "aws_secretsmanager_secret" "serpapi_api_key" {
    name        = "serpapi-api-key"
    description = "SerpAPI Key"

    tags = local.default_tags
}

resource "aws_secretsmanager_secret_version" "ghsa_api_key" {
    secret_id     = aws_secretsmanager_secret.ghsa_api_key.id
    secret_string = var.github_token

    lifecycle {
        ignore_changes = [secret_string]
    }
}

resource "aws_secretsmanager_secret_version" "nvd_api_key" {
    secret_id     = aws_secretsmanager_secret.nvd_api_key.id
    secret_string = var.nvd_api_key

    lifecycle {
        ignore_changes = [secret_string]
    }
}

resource "aws_secretsmanager_secret_version" "nvidia_api_key" {
    secret_id     = aws_secretsmanager_secret.nvidia_api_key.id
    secret_string = var.nvidia_api_key

    lifecycle {
        ignore_changes = [secret_string]
    }
}

resource "aws_secretsmanager_secret_version" "serpapi_api_key" {
    secret_id     = aws_secretsmanager_secret.serpapi_api_key.id
    secret_string = var.serpapi_api_key

    lifecycle {
        ignore_changes = [secret_string]
    }
}