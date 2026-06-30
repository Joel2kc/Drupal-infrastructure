# Kubernetes Deployment Configuration

This folder contains the Kubernetes manifests for deploying the Drupal HA 
application to Azure Kubernetes Service (AKS).

## Architecture

The Kubernetes deployment mirrors the VM-based architecture with these components:

- Drupal application running as a Deployment with 2 replicas across 2 nodes
- MySQL running as a StatefulSet with persistent storage
- LoadBalancer Service replacing the Application Gateway
- HorizontalPodAutoscaler scaling pods between 2 and 5 based on CPU and memory
- PodAntiAffinity rules ensuring replicas never land on the same node

## Deploying to AKS

1. Create an AKS cluster with 2 nodes across 2 availability zones
2. Connect kubectl to the cluster
3. Apply the manifests in order:
   - kubectl apply -f namespace.yml
   - kubectl apply -f mysql-secret.yml
   - kubectl apply -f mysql-deployment.yml
   - kubectl apply -f drupal-deployment.yml
   - kubectl apply -f hpa.yml
5. Get the external IP: kubectl get svc drupal-service -n drupal-production