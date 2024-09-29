# ArgoCD

The project contains an ArgoCD module to facilitate the ArgoCD deployment using [argo-cd helmchart](https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd)
It also provides the ability to deploy argoCD Applications, Projects, or ApplicationSet using [argocd-apps helm chart](https://github.com/argoproj/argo-helm/tree/main/charts/argocd-apps)

## Repo Connection
To allow ArgoCD to connect to a particular repo, use `var.repository_secrets` that supports the repo connection methods noted in https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#repositories

See below the example of using ssh and github app for repo connection

## Example

```
module "argocd" {
  source = "./module/"

  name = "argocd"
  repository_secrets = [
    {
      name = "ssh-argo-secret"
      labels = {
        "argocd.argoproj.io/secret-type" = "repo-creds"
      }
      data = {
        "type"          = "git"
        "url"           = "<ssh_git_repo_url>" # e.g git@github.com:argoproj
        "sshPrivateKey" = <ssh_private_key_value>
      }
    },
    {
      name = "githubapp"
      labels = {
        "argocd.argoproj.io/secret-type" = "repo-creds"
      }
      data = {
        "type" = "git"
        "url"  = "https://github.com/reponame"

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

```
