# Time Check Pod - Kubernetes Deployment

## Overview

This project contains Kubernetes manifests for deploying a time-check pod in the `devops` namespace. The pod runs a simple busybox container that logs timestamps at regular intervals for testing and monitoring purposes.

## Components

### 1. ConfigMap (`time-config`)
- **Name**: `time-config`
- **Namespace**: `devops`
- **Purpose**: Stores the time frequency configuration
- **Data**: `TIME_FREQ=5` (logs timestamp every 5 seconds)

### 2. Pod (`time-check`)
- **Name**: `time-check`
- **Namespace**: `devops`
- **Container**: `time-check` using `busybox:latest` image
- **Function**: Continuously logs timestamps to a file
- **Log Location**: `/opt/sysops/time/time-check.log`

## Prerequisites

- Kubernetes cluster (accessible from jump_host)
- `kubectl` utility configured and working
- Appropriate permissions to create resources in the `devops` namespace

## Deployment Steps

### Step 1: Create the Namespace

First, ensure the `devops` namespace exists:

```bash
kubectl create namespace devops
```

If the namespace already exists, you'll see a message indicating so, which is fine.

### Step 2: Deploy the ConfigMap

Apply the ConfigMap configuration:

```bash
kubectl apply -f time-config-configmap.yaml
```

**Expected Output:**
```
configmap/time-config created
```

### Step 3: Deploy the Pod

Apply the Pod configuration:

```bash
kubectl apply -f time-check-pod.yaml
```

**Expected Output:**
```
pod/time-check created
```

### Step 4: Verify Deployment

Check if the pod is running:

```bash
kubectl get pods -n devops
```

**Expected Output:**
```
NAME         READY   STATUS    RESTARTS   AGE
time-check   1/1     Running   0          30s
```

## Verification and Testing

### Check Pod Status

```bash
kubectl get pods -n devops time-check
```

### View Pod Details

```bash
kubectl describe pod time-check -n devops
```

### Check ConfigMap

```bash
kubectl get configmap time-config -n devops -o yaml
```

### View Logs in Real-Time

```bash
kubectl exec -n devops time-check -- tail -f /opt/sysops/time/time-check.log
```

### View All Logged Entries

```bash
kubectl exec -n devops time-check -- cat /opt/sysops/time/time-check.log
```

### Check Container Logs (stdout)

```bash
kubectl logs -n devops time-check
```

## Architecture Details

### Container Command

The container executes the following command:

```bash
while true; do date; sleep $TIME_FREQ; done >> /opt/sysops/time/time-check.log
```

This command:
- Runs an infinite loop
- Executes the `date` command to print current timestamp
- Sleeps for `$TIME_FREQ` seconds (5 seconds by default)
- Appends output to `/opt/sysops/time/time-check.log`

### Environment Variable

The `TIME_FREQ` environment variable is injected from the ConfigMap:

```yaml
env:
- name: TIME_FREQ
  valueFrom:
    configMapKeyRef:
      name: time-config
      key: TIME_FREQ
```

### Volume Configuration

- **Volume Type**: `emptyDir` (ephemeral storage)
- **Volume Name**: `log-volume`
- **Mount Path**: `/opt/sysops/time`
- **Purpose**: Provides persistent storage for logs during pod lifetime

**Note**: Since `emptyDir` is used, logs will be lost when the pod is deleted.

## Configuration Changes

### Modify Log Frequency

To change the logging frequency, update the ConfigMap:

```bash
kubectl edit configmap time-config -n devops
```

Change the `TIME_FREQ` value to your desired interval (in seconds).

**Important**: After updating the ConfigMap, you must restart the pod for changes to take effect:

```bash
kubectl delete pod time-check -n devops
kubectl apply -f time-check-pod.yaml
```

## Troubleshooting

### Pod Not Starting

Check pod events:
```bash
kubectl describe pod time-check -n devops
```

### ConfigMap Not Found

Verify ConfigMap exists:
```bash
kubectl get configmap -n devops
```

### Permission Issues

Ensure you have the necessary RBAC permissions:
```bash
kubectl auth can-i create pods -n devops
kubectl auth can-i create configmaps -n devops
```

### Log File Empty

Wait a few seconds after pod creation, then check again:
```bash
kubectl exec -n devops time-check -- cat /opt/sysops/time/time-check.log
```

## Cleanup

To remove all resources:

```bash
kubectl delete pod time-check -n devops
kubectl delete configmap time-config -n devops
```

To also remove the namespace (if desired):

```bash
kubectl delete namespace devops
```

## Future Integration

This pod is currently deployed for testing purposes. When ready for production integration:

1. Consider using a DaemonSet or Deployment instead of a standalone Pod
2. Implement persistent volume claims (PVC) for log retention
3. Add resource limits and requests
4. Configure log rotation mechanisms
5. Set up monitoring and alerting
6. Consider using a sidecar container for log shipping

## Notes

- The `emptyDir` volume means logs are ephemeral and will be lost when the pod is deleted
- For production use, consider using PersistentVolumeClaims for log retention
- The busybox image is minimal and efficient for simple tasks like this
- Log files will grow continuously; implement log rotation for long-running deployments

## Support

For issues or questions, contact the Nautilus DevOps team.
