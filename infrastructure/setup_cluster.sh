#!/bin/bash
set -e

CLUSTER_NAME="jupyterhub-cluster"

# Check if kind is installed
if ! command -v kind &> /dev/null; then
    echo "kind is not installed. Please install kind first."
    exit 1
fi

# Check if docker is running
if ! docker info &> /dev/null; then
    echo "Docker is not running. Please start Docker."
    exit 1
fi

# Determine project root (assuming script is in infrastructure/)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SHARED_DATA_DIR="$PROJECT_ROOT/shared_data"

# Create shared directory if it doesn't exist
if [ ! -d "$SHARED_DATA_DIR" ]; then
    echo "Creating shared data directory at $SHARED_DATA_DIR"
    mkdir -p "$SHARED_DATA_DIR"
fi

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
  - hostPath: $SHARED_DATA_DIR
    containerPath: /data/shared
  extraPortMappings:
  - containerPort: 30080
    hostPort: 8080
    protocol: TCP
EOF
    echo "Cluster $CLUSTER_NAME created successfully."
fi

# Set kubectl context
kubectl cluster-info --context kind-$CLUSTER_NAME
