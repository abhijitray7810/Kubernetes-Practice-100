# HTTPD ReplicationController Deployment

## Overview
This repository contains the Kubernetes ReplicationController configuration for deploying a highly available HTTPD web server infrastructure for the Nautilus DevOps team.

## Prerequisites
- Kubernetes cluster access
- `kubectl` utility configured on jump_host
- Appropriate permissions to create ReplicationController resources

## Architecture
- **Application**: Apache HTTPD Web Server
- **High Availability**: 3 replicas for redundancy
- **Container Image**: httpd:latest
- **Deployment Method**: ReplicationController

## Specifications

| Parameter | Value |
|-----------|-------|
| ReplicationController Name | httpd-replicationcontroller |
| Container Name | httpd-container |
| Image | httpd:latest |
| Replicas | 3 |
| Label: app | httpd_app |
| Label: type | front-end |
| Container Port | 80 |

## Deployment Instructions

### Step 1: Create the Manifest File
```bash
cat > httpd-replicationcontroller.yaml << 'EOF'
apiVersion: v1
kind: ReplicationController
metadata:
  name: httpd-replicationcontroller
  labels:
    app: httpd_app
    type: front-end
spec:
  replicas: 3
  selector:
    app: httpd_app
    type: front-end
  template:
    metadata:
      labels:
        app: httpd_app
        type: front-end
    spec:
      containers:
      - name: httpd-container
        image: httpd:latest
        ports:
        - containerPort: 80
EOF
```

### Step 2: Deploy the ReplicationController
```bash
kubectl apply -f httpd-replicationcontroller.yaml
```

### Step 3: Verify Deployment
```bash
# Check ReplicationController status
kubectl get rc httpd-replicationcontroller

# List all pods with labels
kubectl get pods -l app=httpd_app,type=front-end

# Check detailed pod status
kubectl get pods -l app=httpd_app,type=front-end -o wide

# Describe the ReplicationController
kubectl describe rc httpd-replicationcontroller
```

## Verification Commands

### Check Pod Status
```bash
kubectl get pods -l app=httpd_app
```

### View Pod Logs
```bash
# Replace <pod-name> with actual pod name
kubectl logs <pod-name>
```

### Check Pod Details
```bash
kubectl describe pod <pod-name>
```

### Monitor Pod Events
```bash
kubectl get events --sort-by='.lastTimestamp' | grep httpd
```

## Management Operations

### Scaling
To change the number of replicas:
```bash
kubectl scale rc httpd-replicationcontroller --replicas=5
```

### Update Image
```bash
kubectl set image rc/httpd-replicationcontroller httpd-container=httpd:2.4
```

### Delete a Pod (ReplicationController will recreate it)
```bash
kubectl delete pod <pod-name>
```

### Delete ReplicationController
```bash
# Delete RC and all pods
kubectl delete rc httpd-replicationcontroller

# Delete RC but keep pods running
kubectl delete rc httpd-replicationcontroller --cascade=orphan
```

## Troubleshooting

### Pods Not Starting
```bash
# Check pod events
kubectl describe pod <pod-name>

# Check ReplicationController events
kubectl describe rc httpd-replicationcontroller

# View pod logs
kubectl logs <pod-name>
```

### Image Pull Errors
```bash
# Verify image availability
docker pull httpd:latest

# Check pod status
kubectl get pods -o yaml | grep -A 5 "image:"
```

### Selector Mismatch
Ensure the selector in the ReplicationController spec matches the labels in the pod template.

## High Availability Features
- **Self-Healing**: Automatically replaces failed pods
- **Desired State**: Maintains exactly 3 replicas at all times
- **Load Distribution**: Distributes pods across available nodes
- **Zero-Downtime**: Ensures continuous availability during pod failures

## Best Practices
1. Always use specific image tags in production (avoid `latest`)
2. Implement resource requests and limits
3. Add liveness and readiness probes
4. Use labels consistently for easy management
5. Monitor pod health and logs regularly

## Notes
- ReplicationController is a legacy resource; consider using Deployment for new applications
- The kubectl utility on jump_host is pre-configured for cluster access
- All pods must be in Running state post-deployment
- Default namespace is used unless specified otherwise

## Labels
- `app: httpd_app` - Application identifier
- `type: front-end` - Application tier classification

## Support
For issues or questions, contact the Nautilus DevOps team.

## License
Internal use for Nautilus Infrastructure.
