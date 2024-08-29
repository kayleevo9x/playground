# playground

***Notes: Repo is still working in progress, additional features, documentations will be added in the coming days***

Playground projects dedicated for personal showcases and experimental projects in a local Kind Kubernetes cluster

## Requirements
```
- python 3.12+
- docker 
- poetry 1.8.3+
- terraform
```

## Project Desciption

The project is created to demonstrate a Devops oriented solution to automatically build and deploy a REST API on a local Kubernetes Cluster with observability and auto-scaling ability

![Project Description](/docs/images/project.png)

***Notes: Project has only been tested on MacOS. The future planning is to also support Windows platform*** 

### Technologies 

- [KinD](https://kind.sigs.k8s.io/) - local Kubernetes Cluster
- [Prometheus](https://prometheus.io/) - observability
- [Github Actions](https://docs.github.com/en/actions) - CI to test, build and push images
- [Docker](https://www.docker.com/) - Containers packaging 
- [ArgoCD](https://argo-cd.readthedocs.io/en/stable/) - CD to deploy and sync applications
- [Helm](https://helm.sh/) to manage Kubernetes deployments
- [Terraform](https://developer.hashicorp.com/terraform) - Infrastructure as Code
- [Python](https://www.python.org/) - FastAPI application scripting
- [Postgresql](https://www.postgresql.org/) - Database


### Project Details

| Project | Description |
|-------------|-------------|
| [local-kind-cluster](/local-kind-cluster/) | Stand up a local Kind Kubernetes cluster and pre-install base features for a successful deployment |
| [url-shortener](/url-shortener/) | My simple web API to generate a short URL from a full URL and store it in a Postgressql database for demonstration purposes |
| [argocd](/argocd/) | Install argoCD into the local kind cluster and hook it up with [argocd-apps](/argocd-apps/) to deploy and sync the web API application |
| [argocd-apps](/argocd-apps/) | Contain helm charts to deploy postgresql and web API app using ArgoCD app-of-apps pattern |

### Instructions

***Notes: Each of the project should have its own README.md for additional details***

Please feel free to fork the repo to explore the full solution including Github Actions and ArgoCD for CI/CD

Or just simply clone the repo and follow the below instructions to explore Kubenertes, k8s resources deployments and ArgoCD in action

1. Install local Kind Kubenertes Cluster using `./local-kind-cluster/start-cluster.sh` 
The project will also pre-install the following:
- Prometheus: [http://localhost/prometheus/](http://localhost/prometheus/)
- Grafana: [http://localhost/grafana/](http://localhost/grafana/). For demonstration purpose: 
``` 
    username: admin
    password: admin
```
- `Nginx Ingress Controller` for Kind
- Secrets to be used by Postgresql and web API deployments

2. Build and push web API docker image to Github Container Registry
Navigate to `/url-shortener` to build and push the web API docker image to your GCR or modify the script to push to other registry of your choice
Set `GITHUB_TOKEN` environment varible in the console to access the target GCR
    export GITHUB_TOKEN=<PAT>

Run the following script to build and push the image

    tag=$(poetry version --short)
    ./docker-build-push.sh -t $tag -r <registry repo name> -u <registry username>

***NOTES:*** `poetry version` acts as the web API version source of truth. If there's a version upgrade, Github action is triggered on `push` event, update the `url-shortener` helm chart version. ArgoCD will automatically pull the change and deploy the app with the new image version

On success, a package should be available in the target GRC

![](/docs/images/package.png)

3. Deploy ArgoCD for CD solution and connect it to the api deployment helm charts
ArgoCD supports different method to connect to a particular repo such as using `ssh`, `https` or `github app`. For this demonstration, we will use github App
- Click on Github Profile on the top right corner > Settings > Developer setting > Github Apps > New Github App
- Fill in the `Github App name`, Homepage URL for your personal website, if not available, use your github URL
- Select repository permissions: `Contents: Read Write`. Permission can be adjusted afterward as needed
- Rename the `pem` file to `argocdplayground.private-key.pem` and save the private key in `/files` 
- Run `terraform apply` to start deploying argoCD into the local k8s cluster

On successful deployment
- ArgoCD is accessible at http://localhost/argocd

![](/docs/images/argo.png)

- To login

```
username: admin
password: Run this command - kubectl -n argocd get secret argocd-initial-admin-secret -o json | jq -r '.data["password"]' | base64 -d
```