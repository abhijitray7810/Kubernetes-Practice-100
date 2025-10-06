# HTTPD Kubernetes Deployment

This repository contains the configuration files and commands to deploy an Apache HTTP Server (httpd) application on a Kubernetes cluster.

## 📋 Overview

This deployment creates a Kubernetes deployment named `httpd` that runs the Apache HTTP Server using the official `httpd:latest` Docker image.

## 🗂️ Files

- **httpd-deployment.yaml**: Kubernetes deployment manifest file
- **commands.md**: Comprehensive list of kubectl commands for managing the deployment
- **README.md**: This file - project documentation

## 🚀 Quick Start

### Prerequisites

- Kubernetes cluster up and running
- `kubectl` CLI tool installed and configured
- Access to the jump_host with kubectl configured to interact with the cluster

### Deployment Steps

1. **Clone or download the files** to your jump_host

2. **Deploy the application**:
   ```bash
   kubectl apply -f httpd-deployment.yaml
   ```

3. **Verify the deployment**:
   ```bash
   kubectl get deployments
   kubectl get pods
   ```

4. **Check the status**:
   ```bash
   kubectl describe deployment httpd
   ```

## 📦 Deployment Specifications

| Property | Value |
|----------|-------|
| Deployment Name | httpd |
| Container Image | httpd:latest |
| Replicas | 1 |
| Container Port | 80 |
| Labels | app: httpd |

## 🔧 Configuration Details

### Deployment Structure

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: httpd
spec:
  replicas: 1
  selector:
    matchLabels:
      app: httpd
  template:
    spec:
      containers:
      - name: httpd
        image: httpd:latest
        ports:
        - containerPort: 80
```

### Key Features

- **Declarative Configuration**: Uses YAML manifest for infrastructure as code
- **Label Selectors**: Uses `app: httpd` label for pod selection
- **Port Mapping**: Exposes container port 80 for HTTP traffic
- **Latest Image**: Uses the latest stable version of Apache httpd

## 🌐 Exposing the Application

To make the application accessible, create a service:

```bash
# NodePort service
kubectl expose deployment httpd --type=NodePort --port=80

# LoadBalancer service (for cloud environments)
kubectl expose deployment httpd --type=LoadBalancer --port=80
```

Then get the service details:
```bash
kubectl get services httpd
```

## 📊 Monitoring and Management

### Check Application Health
```bash
# View deployment status
kubectl get deployments httpd

# View pod status
kubectl get pods -l app=httpd

# View logs
kubectl logs -l app=httpd -f
```

### Scaling
```bash
# Scale to 3 replicas
kubectl scale deployment httpd --replicas=3
```

### Rolling Updates
```bash
# Update to a specific version
kubectl set image deployment/httpd httpd=httpd:2.4

# Monitor rollout
kubectl rollout status deployment/httpd
```

## 🐛 Troubleshooting

### Pod Not Starting
```bash
kubectl describe pod -l app=httpd
kubectl logs -l app=httpd
```

### Check Cluster Resources
```bash
kubectl get nodes
kubectl top nodes
kubectl top pods
```

### Common Issues

1. **Image Pull Errors**: Ensure the cluster has internet access to pull the httpd:latest image
2. **Resource Constraints**: Check if the cluster has sufficient CPU/memory
3. **Network Issues**: Verify network policies and service configurations

## 🧹 Cleanup

To remove the deployment:

```bash
# Delete deployment
kubectl delete -f httpd-deployment.yaml

# Or using the deployment name
kubectl delete deployment httpd

# Delete service (if created)
kubectl delete service httpd
```

## 📚 Additional Resources

- [Kubernetes Deployments Documentation](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Apache HTTP Server Docker Image](https://hub.docker.com/_/httpd)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

## 👥 Team

Nautilus DevOps Team

## 📄 License

Internal use for Nautilus DevOps team.

---

**Note**: This deployment is configured for the Nautilus Kubernetes cluster. Ensure kubectl is properly configured on jump_host before executing any commands.
```
