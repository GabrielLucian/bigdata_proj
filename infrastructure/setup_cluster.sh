#!/bin/bash
set -e

CLUSTER_NAME="jupyterhub-cluster"

# Create cluster if it doesn't exist
if kind get clusters | grep -q "^$CLUSTER_NAME$"; then
    echo "Cluster $CLUSTER_NAME already exists."
else
    echo "Creating cluster $CLUSTER_NAME..."
    cat <<EOF | kind create cluster --name $CLUSTER_NAME --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraMounts:
  - hostPath: /jhub-pool/userdata
    containerPath: /var/local-path-provisioner
  extraPortMappings:
  - containerPort: 30080
    hostPort: 8080
    protocol: TCP
EOF
    echo "Cluster $CLUSTER_NAME created successfully."
fi

# Set kubectl context
kubectl cluster-info --context kind-$CLUSTER_NAME
