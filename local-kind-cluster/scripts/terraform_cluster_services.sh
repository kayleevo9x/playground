#!/bin/bash
echo "Deloy nginx ingress"
cd cluster_services/terraform
terraform init
terraform apply -auto-approve
echo "Deloy nginx ingress"
