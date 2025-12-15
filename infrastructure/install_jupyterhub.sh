#!/bin/bash
set -e

NAMESPACE="jhub"
RELEASE_NAME="jupyterhub"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CONFIG_FILE="$SCRIPT_DIR/config.yaml"

# Check if helm is installed
if ! command -v helm &> /dev/null; then
    echo "helm is not installed. Please install helm first."
    exit 1
fi

# Add JupyterHub helm repo
echo "Adding JupyterHub Helm repository..."
helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/ || echo "JupyterHub repository might already exist, skipping add."
helm repo update

# Create namespace if it doesn't exist
if ! kubectl get namespace $NAMESPACE &> /dev/null; then
    echo "Creating namespace $NAMESPACE..."
    kubectl create namespace $NAMESPACE
fi

# Install or Upgrade JupyterHub
echo "Installing/Upgrading JupyterHub..."
helm upgrade "$RELEASE_NAME" jupyterhub/jupyterhub \
  --install \
  --cleanup-on-fail \
  --namespace "$NAMESPACE" \
  --create-namespace \
  --version=3.3.8 \
  --values "$CONFIG_FILE"

echo "JupyterHub installation completed."
echo "You can access JupyterHub at http://localhost:8080 after the pods are ready."
echo "Run 'kubectl get pods -n $NAMESPACE' to check the status."
