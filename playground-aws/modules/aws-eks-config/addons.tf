module "eks_data_addons" {
  count   = var.enable_nvidia_device_plugin ? 1 : 0
  source  = "aws-ia/eks-data-addons/aws"
  version = "1.33.0"

  oidc_provider_arn           = module.eks.eks_oidc_arn
  enable_nvidia_device_plugin = true
  nvidia_device_plugin_helm_config = {
    version = "0.17.1"
    name    = "nvidia-device-plugin"
    values = [
      <<-EOT
        cli: "none"
        config:
          map:
            default: |-
              version: v1
              flags:
                migStrategy: none
              sharing:
                timeSlicing:
                  renameByDefault: true
                  resources:
                    - name: nvidia.com/gpu
                      replicas: 4
        gfd:
          enabled: true
        nfd:
          master:
            tolerations:
              - key: nvidia.com/gpu
                operator: Exists
                effect: NoSchedule
              - key: nvidia.com/gpu-shared
                operator: Exists
                effect: NoSchedule
          worker:
            tolerations:
              - key: nvidia.com/gpu
                operator: Exists
                effect: NoSchedule
              - key: nvidia.com/gpu-shared
                operator: Exists
                effect: NoSchedule
        tolerations:
          - key: CriticalAddonsOnly
            operator: Exists
          - key: nvidia.com/gpu
            operator: Exists
            effect: NoSchedule
          - key: nvidia.com/gpu-shared
            operator: Exists
            effect: NoSchedule
      EOT
    ]
  }
}