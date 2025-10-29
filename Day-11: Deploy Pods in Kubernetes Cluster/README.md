# Kubernetes Pod Deployment - httpd

This repository contains the Kubernetes manifest for deploying an Apache HTTP Server (httpd) pod.

## Overview

This deployment creates a single pod running the latest version of the Apache HTTP Server using the official `httpd` Docker image.

## Pod Specifications

- **Pod Name**: `pod-httpd`
- **Container Name**: `httpd-container`
- **Image**: `httpd:latest`
- **Labels**: `app=httpd_app`

## Prerequisites

- Access to a Kubernetes cluster
- `kubectl` utility installed and configured on jump_host
- Appropriate permissions to create pods in the cluster

## Deployment Instructions

### Method 1: Using YAML Manifest (Recommended)

1. Save the `pod-httpd.yaml` file to your local system

2. Apply the manifest to create the pod:
```bash
kubectl apply -f pod-httpd.yaml
```

3. Verify the pod creation:
```bash
kubectl get pod pod-httpd
```

### Method 2: Using kubectl run Command

Alternatively, you can create the pod imperatively:
```bash
kubectl run pod-httpd --image=httpd:latest --labels=app=httpd_app
```

Note: This method doesn't allow custom container naming.

## Verification Steps

### Check Pod Status
```bash
kubectl get pod pod-httpd
```

Expected output:
```
NAME        READY   STATUS    RESTARTS   AGE
pod-httpd   1/1     Running   0          30s
```

### View Detailed Pod Information
```bash
kubectl describe pod pod-httpd
```

### Check Pod Labels
```bash
kubectl get pod pod-httpd --show-labels
```

### View Container Logs
```bash
kubectl logs pod-httpd
```

### Access Pod Shell (for troubleshooting)
```bash
kubectl exec -it pod-httpd -- /bin/bash
```

## Pod Management

### Delete the Pod
```bash
kubectl delete pod pod-httpd
```

Or using the manifest file:
```bash
kubectl delete -f pod-httpd.yaml
```

### Update the Pod
To update the pod configuration, you must delete and recreate it:
```bash
kubectl delete pod pod-httpd
kubectl apply -f pod-httpd.yaml
```

## Troubleshooting

### Pod is in Pending State
```bash
kubectl describe pod pod-httpd
```
Check the Events section for issues like insufficient resources or image pull problems.

### Pod is in ImagePullBackOff or ErrImagePull
- Verify internet connectivity
- Check if the image name is correct
- Ensure the cluster can access Docker Hub

### Pod is CrashLoopBackOff
```bash
kubectl logs pod-httpd
```
Review logs to identify application errors.

## Network Access

By default, this pod is not exposed externally. To access the httpd service:

### Port Forward (for testing)
```bash
kubectl port-forward pod-httpd 8080:80
```
Then access: http://localhost:8080

### Create a Service (for persistent access)
```bash
kubectl expose pod pod-httpd --type=NodePort --port=80
```

## Additional Information

- The httpd image runs Apache HTTP Server on port 80 by default
- The container serves content from `/usr/local/apache2/htdocs/`
- Default document root contains a simple "It works!" page

## Team Notes

- Created for: Nautilus DevOps Team
- Purpose: Kubernetes learning and application management
- Environment: Configured via jump_host

## Support

For issues or questions, contact the DevOps team or refer to the official Kubernetes documentation:
- https://kubernetes.io/docs/
- https://hub.docker.com/_/httpd
