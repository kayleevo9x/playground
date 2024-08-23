# playground

Playground projects dedicated for personal showcases and experimental projects in a local Kind Kubernetes cluster

## Project Desciption

The project is created to demonstrate a Devops oriented solution to automatically deploy a REST API on a local Kubernetes Cluster with observability and auto-scaling ability

![](/docs/images/project.png)

## Technologies 

- [KinD](https://kind.sigs.k8s.io/) - local Kubernetes Cluster
- [Prometheus](https://prometheus.io/) - observability
- [Github Actions](https://docs.github.com/en/actions) - CI to test, build and push images
- [Docker](https://www.docker.com/) - Containers packaging 
- [ArgoCD](https://argo-cd.readthedocs.io/en/stable/) for CD
- [Helm](https://helm.sh/) to manage Kubernetes deployments
- [Terraform](https://developer.hashicorp.com/terraform) - Infrastructure as Code
- [Python](https://www.python.org/) - FastAPI application scripting

### Project Details
1. Install local Kind Kubenertes Cluster using `./local-kind-cluster/start-cluster.sh` 
- It will also pre-install a metrics stack comprising of `Prometheus`, `Grafana` and `AlertManager` that are browsable at
- Prometheus Console: [http://localhost/prometheus/](http://localhost/prometheus/)
- Grafana Dashboard: [http://localhost/grafana/](http://localhost/grafana/)
 