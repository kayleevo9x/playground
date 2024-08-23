#!/bin/bash

MACHINE=`uname`
KIND_CLUSTER_NAME=$1
set -e

./scripts/download_execs.sh `pwd`

if ! hash terraform &> /dev/null
then
    echo "The command terraform could not be found."
    echo "-->> Please ensure terraform is in your PATH <<--"
    exit
fi

if [ "$MACHINE" = "Darwin" ]; then
  if [[ $(uname -m) == 'arm64' ]]; then
    ./kind-with-registry.sh ./executables/macos/kind-darwin-arm64 $KIND_CLUSTER_NAME
  else
    ./kind-with-registry.sh ./executables/macos/kind-darwin-amd64 $KIND_CLUSTER_NAME
  fi
  
else
  ./kind-with-registry.sh ./executables/linux/kind-linux-amd64 $KIND_CLUSTER_NAME
fi

./scripts/terraform_cluster_services.sh
