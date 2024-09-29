module "argocd" {
  source = "./module/"

  name = "argocd"
  repository_secrets = [
    {
      name = "kayleevplayground-githubapp"
      labels = {
        "argocd.argoproj.io/secret-type" = "repo-creds"
      }
      data = {
        "type" = "git"
        "url"  = "https://github.com/kayleevo9x"

        "githubAppID"             = 980837
        "githubAppInstallationID" = 54223861
        "githubAppPrivateKey"     = file("${path.module}/files/argocdplayground.private-key.pem")
      }
    }
  ]
  argocd_apps_enabled     = true
  argocd_apps_helm_values = file("${path.module}/files/applications.yaml")
  argocd_cm_data          = file("${path.module}/files/argo-cm-data.yaml")
}
