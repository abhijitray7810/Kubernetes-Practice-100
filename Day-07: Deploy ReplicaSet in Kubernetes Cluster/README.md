# HTTPD ReplicaSet Deployment Guide

## Overview
This repository contains the Kubernetes manifest for deploying an Apache HTTP Server (httpd) ReplicaSet as part of the Nautilus DevOps team's application migration to Kubernetes.

## Prerequisites
- Access to `jump_host` with `kubectl` configured
- Kubernetes cluster up and running
- Proper RBAC permissions to create ReplicaSets

## ReplicaSet Specifications

| Property | Value |
|----------|-------|
| **ReplicaSet Name** | httpd-replicaset |
| **Container Name** | httpd-container |
| **Image** | httpd:latest |
| **Replica Count** | 4 |
| **App Label** | httpd_app |
| **Type Label** | front-end |

## Deployment Instructions

### Step 1: Navigate to Project Directory
```bash
cd /path/to/project
```

### Step 2: Apply the ReplicaSet
```bash
kubectl apply -f httpd-replicaset.yaml
```

Expected output:
```
replicaset.apps/httpd-replicaset created
```

### Step 3: Verify Deployment
Check the ReplicaSet status:
```bash
kubectl get replicaset httpd-replicaset
```

Expected output:
```
NAME                DESIRED   CURRENT   READY   AGE
httpd-replicaset    4         4         4       30s
```

### Step 4: Check Pod Status
```bash
kubectl get pods -l app=httpd_app
```

You should see 4 pods in Running state.

## Verification Commands

### View Detailed ReplicaSet Information
```bash
kubectl describe replicaset httpd-replicaset
```

### Check Pod Labels
```bash
kubectl get pods -l app=httpd_app,type=front-end --show-labels
```

### View ReplicaSet Events
```bash
kubectl get events --field-selector involvedObject.name=httpd-replicaset
```

### Check Container Logs (replace pod-name with actual pod name)
```bash
kubectl logs <pod-name> -c httpd-container
```

## Management Operations

### Scale the ReplicaSet
To change the number of replicas:
```bash
kubectl scale replicaset httpd-replicaset --replicas=6
```

### Update the Image (requires editing the manifest)
```bash
kubectl edit replicaset httpd-replicaset
```

### Delete a Pod (ReplicaSet will automatically create a new one)
```bash
kubectl delete pod <pod-name>
```

### Delete the ReplicaSet
```bash
kubectl delete replicaset httpd-replicaset
```

Or using the manifest file:
```bash
kubectl delete -f httpd-replicaset.yaml
```

## Troubleshooting

### Pods Not Starting
Check pod events:
```bash
kubectl describe pod <pod-name>
```

### Image Pull Errors
Verify the image name and tag:
```bash
kubectl get replicaset httpd-replicaset -o jsonpath='{.spec.template.spec.containers[0].image}'
```

### ReplicaSet Not Creating Pods
Check ReplicaSet events:
```bash
kubectl describe replicaset httpd-replicaset
```

Verify selector matches pod labels:
```bash
kubectl get replicaset httpd-replicaset -o yaml | grep -A 5 selector
```

## Architecture Details

The ReplicaSet ensures high availability by maintaining exactly 4 running pods at all times. If any pod fails or is deleted, the ReplicaSet controller automatically creates a replacement pod to maintain the desired count.

### Label Strategy
- **app: httpd_app** - Identifies the application
- **type: front-end** - Categorizes the tier/role

These labels are used by the ReplicaSet selector to manage the pods and can be used for service discovery and network policies.

## Best Practices
- Always specify image tags (avoid using `latest` in production)
- Use resource limits and requests for production workloads
- Implement health checks (readiness and liveness probes)
- Consider using Deployments instead of ReplicaSets for better update strategies

## Support
For issues or questions, contact the Nautilus DevOps team.

## License
Internal use only - Nautilus DevOps Team
