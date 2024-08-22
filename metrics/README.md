# Metrics 

This project uses terraform to deploy Prometheus stack (prometheus, alertmanager and grafana) via `kube-prometheus-stack` helmchart

## Prerequisites 
- Local Kind cluster
- [Kind-compatible NGINX Ingress Controller](https://kind.sigs.k8s.io/docs/user/ingress/)

## Features

The following URls should be working after deployment
- Prometheus Console: [http://localhost/prometheus/](http://localhost/prometheus/)
- Grafana Dashboard: [http://localhost/grafana/](http://localhost/grafana/)