# Kubernetes Shared Volume Pod - Documentation

## Overview
This project demonstrates how to share a volume between multiple containers within a single Kubernetes pod. This is useful for scenarios where containers need to exchange data or share temporary files.

## Architecture
- **Pod Name**: `volume-share-datacenter`
- **Containers**: 2 Debian containers
- **Volume Type**: `emptyDir` (ephemeral storage)
- **Use Case**: Temporary data sharing between containers

## Components

### Container 1: volume-container-datacenter-1
- **Image**: `debian:latest`
- **Mount Path**: `/tmp/ecommerce`
- **Purpose**: Write data to shared volume

### Container 2: volume-container-datacenter-2
- **Image**: `debian:latest`
- **Mount Path**: `/tmp/demo`
- **Purpose**: Read data from shared volume

### Shared Volume: volume-share
- **Type**: `emptyDir`
- **Lifecycle**: Exists for the lifetime of the pod
- **Storage**: Temporary storage on the node

## Prerequisites
- Access to Kubernetes cluster
- `kubectl` configured to work with your cluster
- Appropriate permissions to create pods

## Deployment Instructions

### 1. Create the Pod
```bash
kubectl apply -f volume-share-datacenter.yaml
```

### 2. Verify Pod Status
```bash
kubectl get pods volume-share-datacenter
```

Expected output:
```
NAME                        READY   STATUS    RESTARTS   AGE
volume-share-datacenter     2/2     Running   0          10s
```

### 3. Check Pod Details (Optional)
```bash
kubectl describe pod volume-share-datacenter
```

## Testing Shared Volume

### Create Test File in Container 1
```bash
kubectl exec volume-share-datacenter -c volume-container-datacenter-1 -- \
  /bin/sh -c "echo 'This is test data for shared volume' > /tmp/ecommerce/ecommerce.txt"
```

### Verify File in Container 1
```bash
kubectl exec volume-share-datacenter -c volume-container-datacenter-1 -- \
  cat /tmp/ecommerce/ecommerce.txt
```

Expected output:
```
This is test data for shared volume
```

### Verify File is Accessible in Container 2
```bash
kubectl exec volume-share-datacenter -c volume-container-datacenter-2 -- \
  cat /tmp/demo/ecommerce.txt
```

Expected output:
```
This is test data for shared volume
```

### List Files in Container 2
```bash
kubectl exec volume-share-datacenter -c volume-container-datacenter-2 -- \
  ls -la /tmp/demo/
```

## How It Works

1. **emptyDir Volume**: When the pod is created, Kubernetes creates an empty directory on the node
2. **Volume Mounting**: Both containers mount the same volume at different paths:
   - Container 1: `/tmp/ecommerce`
   - Container 2: `/tmp/demo`
3. **Data Sharing**: Any file written to `/tmp/ecommerce` in Container 1 is immediately visible at `/tmp/demo` in Container 2
4. **Lifecycle**: The volume persists as long as the pod exists. When the pod is deleted, the volume and its data are deleted

## Use Cases

- **Log Aggregation**: One container writes logs, another processes them
- **Data Processing Pipeline**: Containers in a sequence process data
- **Configuration Sharing**: Share configuration files between containers
- **Temporary File Exchange**: Exchange temporary data without external storage

## Troubleshooting

### Pod Not Starting
```bash
kubectl describe pod volume-share-datacenter
kubectl logs volume-share-datacenter -c volume-container-datacenter-1
```

### Cannot Acces
