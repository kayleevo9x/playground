#!/bin/bash
echo "Terraform prerequisites"
cd cluster_services/terraform
terraform init
terraform apply -auto-approve
echo "Finish Terraform prerequisites"
