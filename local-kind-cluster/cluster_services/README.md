# Base Infrastructure

This terraform project includes the base features installed as default when standing up a local cluster 

## Nginx

1. [Kind-compatible NGINX Ingress Controller](https://kind.sigs.k8s.io/docs/user/ingress/)
2. TCP Port Forwarding via Nginx Ingress Controller (tcp-services).

## Metrics

Metrics stack (prometheus, alertmanager and grafana) using `kube-prometheus-stack` helmchart
The following URls should be working after deployment
- Prometheus Console: [http://localhost/prometheus/](http://localhost/prometheus/)
- Grafana Dashboard: [http://localhost/grafana/](http://localhost/grafana/)