# Nginx Kubernetes Deployment

This repository contains the configuration and instructions for deploying an nginx application on Kubernetes.

## Overview

This deployment creates a simple nginx web server running on Kubernetes using the official nginx Docker image with the latest tag.

## Prerequisites

- Access to a Kubernetes cluster
- `kubectl` CLI tool installed and configured on jump_host
- Appropriate permissions to create deployments in the cluster

## Deployment Details

- **Deployment Name**: `nginx`
- **Application**: nginx web server
- **Container Image**: `nginx:latest`
- **Replicas**: 1 (default)
- **Container Port**: 80

## Quick Start

### Method 1: Imperative Command (Fastest)

Create the deployment directly using kubectl:

```bash
kubectl create deployment nginx --image=nginx:latest
```

### Method 2: Declarative YAML (Recommended)

Apply the provided YAML manifest:

```bash
kubectl apply -f nginx-deployment.yaml
```

## Verification

After deploying, verify the deployment status:

```bash
# Check deployment
kubectl get deployments

# Check pods
kubectl get pods

# Check deployment details
kubectl describe deployment nginx
```

Expected output:
```
NAME    READY   UP-TO-DATE   AVAILABLE   AGE
nginx   1/1     1            1           30s
```

## Accessing the Application

To access the nginx application, you have several options:

### Option 1: Port Forward (Testing)

```bash
kubectl port-forward deployment/nginx 8080:80
```

Then access via: `http://localhost:8080`

### Option 2: Create a Service (Recommended)

```bash
# ClusterIP (internal access only)
kubectl expose deployment nginx --port=80 --target-port=80

# NodePort (external access)
kubectl expose deployment nginx --type=NodePort --port=80

# LoadBalancer (if supported by your cluster)
kubectl expose deployment nginx --type=LoadBalancer --port=80
```

## Management Commands

### Scale the deployment
```bash
kubectl scale deployment nginx --replicas=3
```

### Update the image
```bash
kubectl set image deployment/nginx nginx=nginx:1.25
```

### View logs
```bash
kubectl logs -l app=nginx
```

### Delete the deployment
```bash
kubectl delete deployment nginx
```

## Troubleshooting

### Pod not starting
```bash
# Check pod events
kubectl describe pod <pod-name>

# Check logs
kubectl logs <pod-name>
```

### Check resource usage
```bash
kubectl top pods -l app=nginx
```

## File Structure

```
.
├── README.md
└── nginx-deployment.yaml
```

## Additional Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Nginx Official Documentation](https://nginx.org/en/docs/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

## Notes

- The `nginx:latest` tag is used as specified, but for production environments, it's recommended to use specific version tags for better stability and reproducibility
- The kubectl utility on jump_host is pre-configured to communicate with the Kubernetes cluster

## Author

Nautilus DevOps Team

## License

This configuration is provided as-is for educational and operational purposes.
