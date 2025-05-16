#!/bin/sh

echo "Deploying the application"
cd ..
terraform init
terraform apply -auto-approve