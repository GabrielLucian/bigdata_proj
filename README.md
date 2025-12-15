# JupyterHub on Kubernetes

This project contains scripts to set up a local Kubernetes cluster and install JupyterHub using the `zero-to-jupyterhub-k8s` Helm chart.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installation) (Kubernetes in Docker)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Helm](https://helm.sh/docs/intro/install/)

## Directory Structure

- `infrastructure/`: Contains setup scripts and configuration.
  - `config.yaml`: JupyterHub Helm chart configuration values.
  - `setup_cluster.sh`: Script to create a Kind cluster.
  - `install_jupyterhub.sh`: Script to install JupyterHub.

## Usage

1.  **Set up the Kubernetes Cluster:**

    Run the setup script to create a local Kind cluster. This script configures port mapping so you can access JupyterHub at `http://localhost:8080`.

    ```bash
    ./infrastructure/setup_cluster.sh
    ```

2.  **Install JupyterHub:**

    Run the install script to deploy JupyterHub to the cluster.

    ```bash
    ./infrastructure/install_jupyterhub.sh
    ```

3.  **Access JupyterHub:**

    Wait for the pods to be ready:

    ```bash
    kubectl get pods -n jhub
    ```

    Once the `proxy-public` service is running, you can access JupyterHub at:
    [http://localhost:8080](http://localhost:8080)

## Configuration

You can customize the JupyterHub installation by editing `infrastructure/config.yaml`.
