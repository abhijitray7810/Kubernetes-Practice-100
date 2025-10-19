# Kubernetes ReplicaSet Creation Commands - httpd-replicaset

## Overview
This document contains all the commands and steps required to create, deploy, and manage the httpd-replicaset on a Kubernetes cluster.

## Prerequisites
- kubectl utility configured and set up on jump_host
- Access to the Kubernetes cluster
- Proper permissions to create ReplicaSets

## Step 1: Create ReplicaSet YAML Configuration File

Create a file named `httpd-replicaset.yaml` with the following content:

```bash
cat > httpd-replicaset.yaml << 'EOF'
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: httpd-replicaset
  labels:
    app: httpd_app
    type: front-end
spec:
  replicas: 4
  selector:
    matchLabels:
      app: httpd_app
  template:
    metadata:
      labels:
        app: httpd_app
        type: front-end
    spec:
      containers:
        - name: httpd-container
          image: httpd:latest
EOF
```

## Step 2: Deploy the ReplicaSet

Apply the configuration to the Kubernetes cluster:

```bash
kubectl apply -f httpd-replicaset.yaml
```

Alternative command (using create instead of apply):

```bash
kubectl create -f httpd-replicaset.yaml
```

## Step 3: Verify ReplicaSet Creation

### Check ReplicaSet status:
```bash
kubectl get replicaset httpd-replicaset
```

### List all ReplicaSets:
```bash
kubectl get replicasets
```

### Get detailed ReplicaSet information:
```bash
kubectl describe replicaset httpd-replicaset
```

## Step 4: Verify Pod Creation

### Check pods created by the ReplicaSet:
```bash
kubectl get pods -l app=httpd_app
```

### Check pods with all labels:
```bash
kubectl get pods --show-labels
```

### Watch pods in real-time:
```bash
kubectl get pods -l app=httpd_app -w
```

## Step 5: Additional Verification Commands

### Get ReplicaSet with wide output:
```bash
kubectl get replicaset httpd-replicaset -o wide
```

### Get ReplicaSet in YAML format:
```bash
kubectl get replicaset httpd-replicaset -o yaml
```

### Get ReplicaSet in JSON format:
```bash
kubectl get replicaset httpd-replicaset -o json
```

## Step 6: Scaling Commands

### Scale ReplicaSet to different number of replicas:
```bash
kubectl scale replicaset httpd-replicaset --replicas=6
```

### Scale using the YAML file:
```bash
kubectl scale --replicas=6 -f httpd-replicaset.yaml
```

## Step 7: Label Management

### Get pods with specific labels:
```bash
kubectl get pods -l app=httpd_app,type=front-end
```

### Verify labels on ReplicaSet:
```bash
kubectl get replicaset httpd-replicaset --show-labels
```

## Step 8: Deletion Commands

### Delete the ReplicaSet and all its pods:
```bash
kubectl delete replicaset httpd-replicaset
```

### Delete only the ReplicaSet (orphan pods):
```bash
kubectl delete replicaset httpd-replicaset --cascade=orphan
```

### Delete using the YAML file:
```bash
kubectl delete -f httpd-replicaset.yaml
```

## Step 9: Troubleshooting Commands

### Check ReplicaSet events:
```bash
kubectl describe replicaset httpd-replicaset | grep -A 10 Events
```

### Check pod logs:
```bash
kubectl logs -l app=httpd_app
```

### Check pod details:
```bash
kubectl describe pod <pod-name>
```

### Execute into a pod:
```bash
kubectl exec -it <pod-name> -- /bin/bash
```

## Configuration Summary

| Parameter | Value |
|-----------|--------|
| ReplicaSet Name | httpd-replicaset |
| Image | httpd:latest |
| Container Name | httpd-container |
| Replicas | 4 |
| Labels | app: httpd_app, type: front-end |
| API Version | apps/v1 |

## Quick Reference Commands

```bash
# Create
kubectl apply -f httpd-replicaset.yaml

# Verify creation
kubectl get replicaset httpd-replicaset
kubectl get pods -l app=httpd_app

# Scale
kubectl scale replicaset httpd-replicaset --replicas=6

# Delete
kubectl delete replicaset httpd-replicaset
```

## Notes
- The ReplicaSet ensures 4 replicas of httpd pods are always running
- Pods are automatically recreated if they fail or are deleted
- Labels are used for pod selection and management
- The httpd:latest image will be pulled from Docker Hub
```

This command.md file provides a comprehensive guide with all the necessary commands to create, manage, and troubleshoot the httpd-replicaset deployment on your Kubernetes cluster.
