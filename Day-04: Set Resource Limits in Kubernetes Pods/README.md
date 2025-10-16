# Kubernetes Pod with Resource Constraints

## Overview

This repository contains the configuration for deploying an Apache HTTP Server (httpd) pod in Kubernetes with specific resource limits to address performance issues in the Nautilus DevOps environment.

## Problem Statement

The Nautilus DevOps team has noticed performance issues in Kubernetes-hosted applications due to resource constraints. To ensure better resource management and prevent resource exhaustion, this pod is configured with explicit resource requests and limits.

## Pod Specification

- **Pod Name**: `httpd-pod`
- **Container Name**: `httpd-container`
- **Image**: `httpd:latest`

### Resource Configuration

#### Requests (Guaranteed Resources)
- **Memory**: 15Mi
- **CPU**: 100m (0.1 CPU cores)

#### Limits (Maximum Resources)
- **Memory**: 20Mi
- **CPU**: 100m (0.1 CPU cores)

## Prerequisites

- Access to the Kubernetes cluster via `jump_host`
- `kubectl` utility configured and operational
- Sufficient cluster resources to accommodate the pod requests

## Deployment Instructions

### Step 1: Create the YAML Manifest

Save the following content to a file named `httpd-pod.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: httpd-pod
spec:
  containers:
  - name: httpd-container
    image: httpd:latest
    resources:
      requests:
        memory: "15Mi"
        cpu: "100m"
      limits:
        memory: "20Mi"
        cpu: "100m"
```

### Step 2: Deploy the Pod

```bash
kubectl apply -f httpd-pod.yaml
```

### Step 3: Verify Deployment

Check if the pod is running:

```bash
kubectl get pod httpd-pod
```

Expected output:
```
NAME        READY   STATUS    RESTARTS   AGE
httpd-pod   1/1     Running   0          10s
```

### Step 4: View Detailed Information

```bash
kubectl describe pod httpd-pod
```

This will show detailed information including resource requests and limits.

## Understanding Resource Constraints

### Requests
- **Purpose**: Guaranteed minimum resources allocated to the pod
- **Scheduler Behavior**: Kubernetes scheduler ensures the node has these resources available before placing the pod
- **Impact**: If these resources aren't available, the pod won't be scheduled

### Limits
- **Purpose**: Maximum resources the pod can consume
- **Memory Limit Behavior**: If exceeded, the pod will be terminated (OOMKilled)
- **CPU Limit Behavior**: If exceeded, the pod will be throttled but not terminated

## Monitoring and Troubleshooting

### Check Pod Status
```bash
kubectl get pod httpd-pod -o wide
```

### View Pod Logs
```bash
kubectl logs httpd-pod
```

### Check Resource Usage
```bash
kubectl top pod httpd-pod
```

### Describe Pod Events
```bash
kubectl describe pod httpd-pod
```

### Common Issues

1. **Pod stuck in Pending state**: Insufficient resources on cluster nodes
   ```bash
   kubectl describe pod httpd-pod | grep -A 5 Events
   ```

2. **Pod getting OOMKilled**: Memory limit too low
   - Check logs: `kubectl logs httpd-pod --previous`
   - Consider increasing memory limit

3. **Pod running slowly**: CPU throttling due to limits
   - Monitor with: `kubectl top pod httpd-pod`
   - Consider adjusting CPU limits if needed

## Cleanup

To delete the pod:

```bash
kubectl delete pod httpd-pod
```

Or using the manifest file:

```bash
kubectl delete -f httpd-pod.yaml
```

## Best Practices

1. **Set Requests and Limits**: Always define both to ensure predictable behavior
2. **Monitor Usage**: Regularly check actual resource consumption
3. **Right-size Resources**: Adjust based on actual application needs
4. **Quality of Service (QoS)**: This pod has "Guaranteed" QoS since requests equal limits
5. **Production Workloads**: Consider using Deployments instead of bare pods for better management

## Additional Resources

- [Kubernetes Resource Management](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
- [Quality of Service for Pods](https://kubernetes.io/docs/tasks/configure-pod-container/quality-service-pod/)
- [Resource Quotas](https://kubernetes.io/docs/concepts/policy/resource-quotas/)

## Contact

For issues or questions, contact the Nautilus DevOps team.

---

**Note**: This configuration is optimized for the Nautilus environment. Adjust resource values based on your specific requirements and monitoring data.
