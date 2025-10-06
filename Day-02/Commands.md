```markdown
# HTTPD Deployment Commands

## Prerequisites
Ensure kubectl is configured to connect to your Kubernetes cluster:
```bash
kubectl cluster-info
kubectl get nodes
```

## Deployment Commands

### Create the Deployment
```bash
# Apply the deployment from YAML file
kubectl apply -f httpd-deployment.yaml
```

### Verify Deployment
```bash
# Check deployment status
kubectl get deployments

# Check deployment details
kubectl describe deployment httpd

# Check pods
kubectl get pods

# Check pods with labels
kubectl get pods -l app=httpd

# Watch pod status in real-time
kubectl get pods -w
```

### View Logs
```bash
# Get logs from the httpd pod
kubectl logs -l app=httpd

# Follow logs in real-time
kubectl logs -l app=httpd -f
```

### Scale the Deployment
```bash
# Scale to 3 replicas
kubectl scale deployment httpd --replicas=3

# Verify scaling
kubectl get deployments
kubectl get pods
```

### Update the Deployment
```bash
# Update the image (if needed)
kubectl set image deployment/httpd httpd=httpd:2.4

# Check rollout status
kubectl rollout status deployment/httpd

# View rollout history
kubectl rollout history deployment/httpd
```

### Expose the Deployment (Optional)
```bash
# Create a service to expose the deployment
kubectl expose deployment httpd --type=NodePort --port=80

# Get service details
kubectl get services

# Or create a LoadBalancer service
kubectl expose deployment httpd --type=LoadBalancer --port=80
```

### Troubleshooting
```bash
# Get detailed pod information
kubectl describe pod -l app=httpd

# Execute commands inside the pod
kubectl exec -it  -- /bin/bash

# Check events
kubectl get events --sort-by=.metadata.creationTimestamp
```

### Cleanup
```bash
# Delete the deployment
kubectl delete deployment httpd

# Delete using the YAML file
kubectl delete -f httpd-deployment.yaml

# Delete the service (if created)
kubectl delete service httpd
```

## Quick Reference

| Command | Description |
|---------|-------------|
| `kubectl apply -f httpd-deployment.yaml` | Create/update deployment |
| `kubectl get deployments` | List all deployments |
| `kubectl get pods` | List all pods |
| `kubectl describe deployment httpd` | Show deployment details |
| `kubectl logs -l app=httpd` | View application logs |
| `kubectl delete deployment httpd` | Delete the deployment |
```

---
