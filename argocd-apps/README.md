# API HelmCharts

This project stores a example that uses the [app-of-apps](https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/#app-of-apps-pattern) pattern to deploy 2 applications to a K8s Cluster

| Application | Description |
|-------------|-------------|
| [guestbook](guestbook/) | A hello word guestbook app from ArgoCD example repo |
| [url-shortener](url-shortener/) | My simple web API to generate a short URL from a full URL and store it in a Postgressql database for demonstration purposes |

![ArgoCD UI showing applications deployed using the app-of-apps pattern](../docs/deployed_app_of_apps.png)

