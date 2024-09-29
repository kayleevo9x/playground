#!/bin/sh
set -o errexit
KIND=$1

# desired cluster name; default is "kind"
KIND_CLUSTER_NAME="${2:-kind}"
KIND_CLUSTER_OPTS=""
# create registry container unless it already exists
reg_name="kind-registry-${KIND_CLUSTER_NAME}"
reg_port='5001'
if [ "$(docker inspect -f '{{.State.Running}}' "${reg_name}" 2>/dev/null || true)" != 'true' ]; then
  docker run \
    -d --restart=always -p "127.0.0.1:${reg_port}:5000" --name "${reg_name}" \
    registry:2
fi

# create a cluster with the local registry enabled in containerd
cat <<EOF | ${KIND} create cluster ${KIND_CLUSTER_OPTS} --kubeconfig=./local-${KIND_CLUSTER_NAME}  --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."localhost:${reg_port}"]
    endpoint = ["http://${reg_name}:5000"]
name: local-$KIND_CLUSTER_NAME
nodes:
    - role: worker
    - role: worker
    - role: control-plane
      kubeadmConfigPatches:
          - |
            kind: InitConfiguration
            nodeRegistration:
              kubeletExtraArgs:
                node-labels: "ingress-ready=true"
      extraPortMappings:
          - containerPort: 80
            hostPort: 80
            protocol: TCP
          - containerPort: 443
            hostPort: 443
            protocol: TCP
          - containerPort: 8001
            hostPort: 8001
            protocol: TCP
          - containerPort: 9001
            hostPort: 9001
            protocol: TCP
          - containerPort: 9000
            hostPort: 9000
            protocol: TCP    
EOF

echo "Connect docker network..."
# connect the registry to the cluster network if not already connected
if [ "$(docker inspect -f='{{json .NetworkSettings.Networks.kind}}' "${reg_name}")" = 'null' ]; then
  docker network connect "kind" "${reg_name}"
fi

echo "Configure local registry in cluster..."
# Document the local registry
# https://github.com/kubernetes/enhancements/tree/master/keps/sig-cluster-lifecycle/generic/1755-communicating-a-local-registry
cat <<EOF | kubectl --kubeconfig=./local-${KIND_CLUSTER_NAME} apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: local-registry-hosting
  namespace: kube-public
data:
  localRegistryHosting.v1: |
    host: "localhost:${reg_port}"
    help: "https://kind.sigs.k8s.io/docs/user/local-registry/"
EOF

echo "KinD cluster setup completed"
