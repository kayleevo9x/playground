#!/bin/sh

cd ../security-group
terraform init
terraform apply -auto-approve 
