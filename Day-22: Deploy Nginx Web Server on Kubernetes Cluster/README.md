# Nginx Static Website Deployment on Kubernetes

## Overview

This repository contains Kubernetes manifests for deploying a highly available and scalable static website using Nginx on a Kubernetes cluster. The deployment is designed for the Nautilus team with multiple replicas to ensure high availability.

## Architecture

- **Deployment**: `nginx-deployment` with 3 replicas
- **Container**: Nginx latest version serving static content
- **Service**: NodePort service exposing the application on port 30011
- **High Availability**: Multiple replicas ensure the application remains available even if pods fail
- **Scalability**: Can easily scale up or down by adjusting replica count

## Prerequisites

- Access to a Kubernetes cluster
- `kubectl` utility configured on `jump_host`
- Appropriate permissions to create deployments and services

## Files

- `nginx-deployment.yaml` - Deployment configuration with 3 Nginx replicas
- `nginx-service.yaml` - NodePort service configuration

## Deployment Instructions

### Step 1: Apply the Deployment

```bash
kubectl apply -f nginx-deployment.yaml
```

This creates a deployment with:
- 3 replicas of Nginx containers
- Container name: `nginx-container`
- Image: `nginx:latest`

### Step 2: Apply the Service

```bash
kubectl apply -f nginx-service.yaml
```

This creates a NodePort service that:
- Exposes the application on port 30011
- Load balances traffic across all replicas

### Step 3: Verify the Deployment

Check deployment status:
```bash
kubectl get deployments nginx-deployment
```

Check running pods:
```bash
kubectl get pods -l app=nginx
```

Check service details:
```bash
kubectl get service nginx-service
```

Get detailed service information:
```bash
kubectl describe service nginx-service
```

## Accessing the Application

Once deployed, the Nginx web server can be accessed at:

```
http://<NODE_IP>:30011
```

Replace `<NODE_IP>` with the IP address of any node in your Kubernetes cluster.

## Configuration Details

### Deployment Specifications

| Parameter | Value |
|-----------|-------|
| Deployment Name | nginx-deployment |
| Container Name | nginx-container |
| Image | nginx:latest |
| Replicas | 3 |
| Container Port | 80 |

### Service Specifications

| Parameter | Value |
|-----------|-------|
| Service Name | nginx-service |
| Service Type | NodePort |
| Port | 80 |
| Target Port | 80 |
| NodePort | 30011 |

## Scaling

To scale the deployment up or down:

```bash
# Scale to 5 replicas
kubectl scale deployment nginx-deployment --replicas=5

# Scale to 2 replicas
kubectl scale deployment nginx-deployment --replicas=2
```

## Troubleshooting

### Check pod logs
```bash
kubectl logs -l app=nginx
```

### Check pod details
```bash
kubectl describe pods -l app=nginx
```

### Check service endpoints
```bash
kubectl get endpoints nginx-service
```

### View deployment events
```bash
kubectl describe deployment nginx-deployment
```

## Updating the Application

To update the Nginx image or configuration:

1. Modify the YAML file
2. Apply the changes:
```bash
kubectl apply -f nginx-deployment.yaml
```

Kubernetes will perform a rolling update automatically.

## Cleanup

To remove all resources:

```bash
kubectl delete -f nginx-service.yaml
kubectl delete -f nginx-deployment.yaml
```

Or delete resources individually:

```bash
kubectl delete service nginx-service
kubectl delete deployment nginx-deployment
```

## Health Checks

Consider adding liveness and readiness probes for production environments:

```yaml
livenessProbe:
  httpGet:
    path: /
    port: 80
  initialDelaySeconds: 30
  periodSeconds: 10

readinessProbe:
  httpGet:
    path: /
    port: 80
  initialDelaySeconds: 5
  periodSeconds: 5
```

## Security Considerations

- The deployment uses `nginx:latest` tag. For production, consider using specific version tags
- Implement resource limits and requests for better resource management
- Consider using Ingress instead of NodePort for production traffic
- Implement network policies for pod-to-pod communication security

## Maintenance

Regular maintenance tasks:
- Monitor pod resource usage
- Check logs for errors
- Update Nginx image periodically for security patches
- Review and adjust replica count based on traffic patterns

## Support

For issues or questions, contact the DevOps team or refer to the Kubernetes and Nginx documentation.

## License

[Add your license information here]
