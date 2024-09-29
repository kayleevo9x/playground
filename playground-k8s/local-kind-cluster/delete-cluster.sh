MACHINE=`uname`

KIND_CLUSTER_NAME="${1:-kind}"

if [ "$MACHINE" = "Darwin" ]; then
  if [[ $(uname -m) == 'arm64' ]]; then
    ./executables/macos/kind-darwin-arm64 delete cluster --name local-${KIND_CLUSTER_NAME} --kubeconfig local-${KIND_CLUSTER_NAME}
  else
    ./executables/macos/kind-darwin-amd64 delete cluster --name local-${KIND_CLUSTER_NAME} --kubeconfig local-${KIND_CLUSTER_NAME}
  fi
  
else
  ./executables/linux/kind-linux-amd64  delete cluster --name local-${KIND_CLUSTER_NAME} --kubeconfig local-${KIND_CLUSTER_NAME}
fi

# delete registry container
reg_name=kind-registry-${KIND_CLUSTER_NAME}
echo "Deleting local-${KIND_CLUSTER_NAME} registry ${reg_name}..."
if [ "$(docker ps -a -q -f name=${reg_name})" ]; then
  docker stop "${reg_name}"
  docker rm "${reg_name}"
  docker rmi "registry:2"
fi
