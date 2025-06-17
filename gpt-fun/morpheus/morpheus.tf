# # Morpheus configuration
resource "kubernetes_namespace" "morpheus" {
  metadata {
    name = "morpheus"
    labels = {
      name = "morpheus"
    }
  }
}


data "aws_secretsmanager_secret_version" "nvidia_api_key" {
  secret_id = aws_secretsmanager_secret.nvidia_api_key.id
}

data "aws_secretsmanager_secret_version" "nvd_api_key" {
  secret_id = aws_secretsmanager_secret.nvd_api_key.id
}

data "aws_secretsmanager_secret_version" "serpapi_key" {
  secret_id = aws_secretsmanager_secret.serpapi_api_key.id
}

resource "kubernetes_secret_v1" "morpheus_secrets" {
  metadata {
    name      = "morpheus-secrets"
    namespace = kubernetes_namespace.morpheus.metadata[0].name
  }
  # It's here mainly so that a valid github_token just needs to be passed in once.
  immutable = true
  type = "Opaque"

  data = {
    NVD_API_KEY     = data.aws_secretsmanager_secret_version.nvd_api_key.secret_string
    NVIDIA_API_KEY  = data.aws_secretsmanager_secret_version.nvidia_api_key.secret_string
    SERPAPI_API_KEY = data.aws_secretsmanager_secret_version.serpapi_key.secret_string
    GHSA_API_KEY    = var.github_token
    NGC_API_KEY     = data.aws_secretsmanager_secret_version.nvidia_api_key.secret_string
    OPENAI_API_KEY  = ""
  }
}

resource "kubernetes_config_map_v1" "morpheus_vuln_analysis_config" {
  metadata {
    name      = "morpheus-vuln-analysis-config"
    namespace = kubernetes_namespace.morpheus.metadata[0].name
  }

  data = {
    TERM                     = ""
    HF_HUB_CACHE             = "/workspace_examples/.cache/huggingface"
    XDG_CACHE_HOME           = "/workspace_examples/.cache/am_cache"
    CVE_DETAILS_BASE_URL     = "http://localhost/cve-details"
    CWE_DETAILS_BASE_URL     = "http://localhost/cwe-details"
    DEPSDEV_BASE_URL         = "http://localhost/depsdev"
    FIRST_BASE_URL           = "http://localhost/first"
    GHSA_BASE_URL            = "http://localhost/ghsa"
    NGC_API_BASE             = "http://localhost/nemo/v1"
    NIM_EMBED_BASE_URL       = "http://localhost/nim_embed/v1"
    NVD_BASE_URL             = "http://localhost/nvd"
    NVIDIA_API_BASE          = "http://localhost/nim_llm/v1"
    OPENAI_API_BASE          = "http://localhost/openai/v1"
    OPENAI_BASE_URL          = "http://localhost/openai/v1"
    RHSA_BASE_URL            = "http://localhost/rhsa"
    SERPAPI_BASE_URL         = "http://localhost/serpapi"
    UBUNTU_BASE_URL          = "http://localhost/ubuntu"
    NGINX_UPSTREAM_NVAI      = "https://api.nvcf.nvidia.com"
    NGINX_UPSTREAM_NIM_LLM   = "http://nims-service.nims.svc.cluster.local:8000"
    NGINX_UPSTREAM_NIM_EMBED = "http://nim-embed-service.nims.svc.cluster.local:8000"
    NGC_ORG_ID               = ""
  }

  depends_on = [
    kubernetes_secret_v1.morpheus_secrets
  ]
}

resource "kubernetes_config_map_v1" "morpheus_entrypoint_script" {
  metadata {
    name      = "morpheus-entrypoint-script"
    namespace = "morpheus"
  }

  data = {
    "entrypoint.sh" = <<-EOT
      #!/bin/bash --login
      # SPDX-FileCopyrightText: Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
      # SPDX-License-Identifier: Apache-2.0
      
      # Activate the `morpheus` conda environment.
      . /opt/conda/etc/profile.d/conda.sh
      conda activate morpheus-vuln-analysis
      
      # Set the Python path to use the Conda environment
      export PYTHONPATH=/opt/conda/envs/morpheus-vuln-analysis/bin:$PYTHONPATH
      
      # Source "source" file if it exists
      SRC_FILE="/opt/docker/bin/entrypoint_source"
      [ -f "$SRC_FILE" ] && source "$SRC_FILE"
      
      # Run the Python command
      python src/main.py --log_level DEBUG cve pipeline --config_file=configs/from_http.json
    EOT
  }

  depends_on = [
    kubernetes_secret_v1.morpheus_secrets
  ]
}

resource "kubernetes_config_map_v1" "nginx_config" {
  metadata {
    name = "nginx-configmap"
    namespace = "morpheus"
  }

  data = {
    "nginx.conf" = file("${path.module}/nginx/nginx_cache.conf")
  }
}


resource "kubernetes_config_map_v1" "morpheus_http_config" {
  metadata {
    name      = "morpheus-http-config"
    namespace = "morpheus"
  }

  data = {
    "from_http.json" = jsonencode({
      "$schema" = "./schemas/config.schema.json"
      engine = {
        agent = {
          model = {
            model_name  = "meta/llama3-8b-instruct"
            service     = { _type = "nvfoundation" }
            max_tokens  = 2000
            temperature = 0
            top_p       = 0.01
            seed        = 42
          }
          verbose         = false,
          max_concurrency = null
        }
        checklist_model = {
          service     = { _type = "nvfoundation" }
          model_name  = "meta/llama3-8b-instruct"
          max_tokens  = 2000
          temperature = 0
          top_p       = 0.01
          seed        = 42
        }
        justification_model = {
          model_name  = "meta/llama3-8b-instruct"
          service     = { _type = "nvfoundation" }
          max_tokens  = 1024
          temperature = 0
          top_p       = 0.01
          seed        = 42
        }
        rag_embedding = {
          _type          = "nim"
          model          = "nvidia/nv-embedqa-e5-v5"
          truncate       = "END"
          max_batch_size = 128
        }
        summary_model = {
          model_name  = "meta/llama3-8b-instruct"
          service     = { _type = "nvfoundation" }
          max_tokens  = 1024
          temperature = 0
          top_p       = 0.01
          seed        = 42
        }
      }
      general = {
        cache_dir            = null
        base_vdb_dir         = ".cache/am_cache/vdb"
        base_git_dir         = ".cache/am_cache/git"
        max_retries          = 5
        model_max_batch_size = 64
        pipeline_batch_size  = 1024
        use_uvloop           = true
      }
      input = {
        _type   = "http"
        port    = 26466
        address = "0.0.0.0"
      }
      output = {
        _type        = "file"
        file_path    = ".tmp/output.json"
        markdown_dir = ".tmp/vulnerability_markdown_reports"
        overwrite    = true
      }
    })
  }

  depends_on = [
    kubernetes_secret_v1.morpheus_secrets
  ]
}

resource "kubernetes_deployment_v1" "morpheus_vuln_analysis" {
  metadata {
    name      = "morpheus-vuln-analysis"
    namespace = "morpheus"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "morpheus-vuln-analysis"
      }
    }

    template {
      metadata {
        labels = {
          app = "morpheus-vuln-analysis"
        }
      }

      spec {
        service_account_name = "morpheus"
        node_selector = {
          "gpu-shared" = "true"
        }
        toleration {
          key      = "nvidia.com/gpu-shared"
          operator = "Exists"
          effect   = "NoSchedule"
        }
        init_container {
          name  = "git-config-init"
          image = "busybox"

          command = [
            "sh", "-c",
            <<-EOF
              echo "[credential]" > /root/.gitconfig
              echo "  helper = store" >> /root/.gitconfig
              echo "[url \"https://token:$${GITHUB_TOKEN}@github.com/\"]" >> /root/.gitconfig
              echo "  insteadOf = https://github.com/" >> /root/.gitconfig
            EOF
          ]

          env {
            name = "GITHUB_TOKEN"
            value_from {
              secret_key_ref {
                name = "morpheus-secrets"
                key  = "GHSA_API_KEY"
              }
            }
          }

          volume_mount {
            name       = "git-config"
            mount_path = "/root"
          }
        }

        container {
          name        = "morpheus-vuln-analysis"
          image       = "nvcr.io/nvidia/morpheus/morpheus-vuln-analysis:24.10"
          working_dir = "/workspace_examples"

          port {
            container_port = 26466
          }

          env_from {
            config_map_ref {
              name = "morpheus-vuln-analysis-config"
            }
          }

          dynamic "env" {
            for_each = ["NVD_API_KEY", "NVIDIA_API_KEY", "SERPAPI_API_KEY", "GHSA_API_KEY", "OPENAI_API_KEY"]
            content {
              name = env.value
              value_from {
                secret_key_ref {
                  name = "morpheus-secrets"
                  key  = env.value
                }
              }
            }
          }
          volume_mount {
            name       = "entrypoint-script"
            mount_path = "/workspace_examples/docker/scripts"
          }

          volume_mount {
            name       = "config-volume"
            mount_path = "/workspace_examples/configs"
          }

          volume_mount {
            name       = "output-volume"
            mount_path = "/workspace_examples/.tmp"
          }

          volume_mount {
            name       = "git-config"
            mount_path = "/root"
          }
          resources {
            requests = {
              cpu    = "2"
              memory = "8Gi"
            }
            limits = {
              cpu                     = "4"
              memory                  = "16Gi"
              "nvidia.com/gpu.shared" = 1
            }
          }
        }
        init_container {
          name    = "init-nginx-files"
          image   = "alpine/git:latest"
          command = ["sh", "-c"]
          args = [
            <<-EOT
            git clone --depth 1 https://github.com/NVIDIA-AI-Blueprints/vulnerability-analysis.git /tmp/repo \
            && cp -r /tmp/repo/nginx/templates/ /mnt/nginx/templates/ 
            EOT
          ]
          volume_mount {
            name       = "nginx-config"
            mount_path = "/mnt/nginx"
          }
        }
        container {
          name  = "nginx-cache"
          image = "nginx:latest"
          port {
            container_port = 80
          }

          volume_mount {
            name       = "nginx-config-volume"
            mount_path = "/etc/nginx/nginx.conf"
            sub_path   = "nginx.conf"
          }
          volume_mount {
            name       = "nginx-config"
            mount_path = "/etc/nginx/templates"
            sub_path   = "templates"
          }
          volume_mount {
            name       = "service-cache"
            mount_path = "/server_cache_intel"
          }

          volume_mount {
            name       = "llm-cache"
            mount_path = "/server_cache_llm"
          }
          env_from {
            config_map_ref {
              name = "morpheus-vuln-analysis-config"
            }
          }
          dynamic "env" {
            for_each = ["NVD_API_KEY", "NVIDIA_API_KEY", "SERPAPI_API_KEY", "GHSA_API_KEY", "NGC_API_KEY", "OPENAI_API_KEY"]
            content {
              name = env.value
              value_from {
                secret_key_ref {
                  name = "morpheus-secrets"
                  key  = env.value
                }
              }
            }
          }
          resources {
            requests = {
              cpu    = "500m"
              memory = "512Mi"
            }
            limits = {
              cpu    = "1"
              memory = "1Gi"
            }
          }
        }
        # container {
        #   name    = "s3-sync"
        #   image   = "amazon/aws-cli"
        #   command = ["/bin/sh", "-c"]
        #   args = [<<-EOT
        #     while true; do
        #       for file in /workspace_examples/.tmp/output*.json; do
        #         if [ -f "$file" ]; then
        #           timestamp=$(date +%Y%m%d%H%M%S)
        #           aws s3 cp "$file" "s3://$S3_BUCKET_NAME/morpheus-output-$timestamp.json"
        #           mv "$file" "$file.uploaded"
        #         fi
        #       done
        #       sleep 60
        #     done
        #   EOT
        #   ]

        #   env {
        #     name = "S3_BUCKET_NAME"
        #     value_from {
        #       config_map_key_ref {
        #         name = "morpheus-config"
        #         key  = "s3-bucket-name"
        #       }
        #     }
        #   }

        #   env {
        #     name = "AWS_DEFAULT_REGION"
        #     value_from {
        #       config_map_key_ref {
        #         name = "morpheus-config"
        #         key  = "aws-region"
        #       }
        #     }
        #   }

        #   volume_mount {
        #     name       = "output-volume"
        #     mount_path = "/workspace_examples/.tmp"
        #   }

        #   resources {
        #     requests = {
        #       cpu    = "100m"
        #       memory = "128Mi"
        #     }
        #     limits = {
        #       cpu    = "200m"
        #       memory = "256Mi"
        #     }
        #   }
        # }
        volume {
          name = "git-config"
          empty_dir {}
        }

        volume {
          name = "entrypoint-script"
          config_map {
            name         = "morpheus-entrypoint-script"
            default_mode = "0777"
          }
        }

        volume {
          name = "config-volume"
          config_map {
            name         = "morpheus-http-config"
            default_mode = "0777"
          }
        }
        volume {
          name = "nginx-config"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.nginx_config.metadata[0].name
          }
        }
        volume {
          name = "nginx-config-volume"
          config_map {
            name = "nginx-configmap"
            items {
                key  = "nginx.conf"
                path = "nginx.conf"
            }
          }
        }
        volume {
          name = "service-cache"
          empty_dir {}
        }

        volume {
          name = "llm-cache"
          empty_dir {}
        }
        volume {
          name = "output-volume"
          empty_dir {}
        }
      }
    }
  }
}
