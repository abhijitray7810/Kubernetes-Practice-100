# Webserver Pod with Sidecar Pattern for Log Aggregation

## Overview

This Kubernetes configuration implements the Sidecar pattern to handle log aggregation for an nginx web server. The solution deploys two containers in a single Pod:
- **nginx-container**: Serves web pages
- **sidecar-container**: Reads and ships logs

This follows the separation of concerns principle, where each container specializes in a single task.

## Architecture

```
┌─────────────────────────────────────────┐
│           webserver Pod                 │
│                                         │
│  ┌──────────────┐    ┌──────────────┐  │
│  │    nginx     │    │   ubuntu     │  │
│  │  container   │    │  container   │  │
│  │              │    │  (sidecar)   │  │
│  └──────┬───────┘    └──────┬───────┘  │
│         │                   │          │
│         │  shared-logs      │          │
│         │  (emptyDir)       │          │
│         └───────────────────┘          │
│           /var/log/nginx               │
└─────────────────────────────────────────┘
```

## Components

### 1. Pod: `webserver`
The main Pod that hosts both containers.

### 2. Volume: `shared-logs`
- **Type**: emptyDir
- **Purpose**: Shared storage for logs between containers
- **Lifecycle**: Exists as long as the Pod is running
- **Mount Path**: `/var/log/nginx` (in both containers)

### 3. Container: `nginx-container`
- **Image**: `nginx:latest`
- **Purpose**: Web server that generates access and error logs
- **Volume Mount**: `/var/log/nginx`

### 4. Container: `sidecar-container`
- **Image**: `ubuntu:latest`
- **Purpose**: Reads and outputs logs every 30 seconds
- **Command**: `sh -c "while true; do cat /var/log/nginx/access.log /var/log/nginx/error.log; sleep 30; done"`
- **Volume Mount**: `/var/log/nginx`

## Deployment Instructions

### Prerequisites
- Kubernetes cluster is running
- `kubectl` is configured on jump_host
- Appropriate permissions to create Pods

### Deploy the Pod

1. **Apply the configuration:**
   ```bash
   kubectl apply -f webserver-pod.yaml
   ```

2. **Verify Pod is running:**
   ```bash
   kubectl get pod webserver
   ```
   
   Expected output:
   ```
   NAME        READY   STATUS    RESTARTS   AGE
   webserver   2/2     Running   0          30s
   ```

3. **Check both containers are running:**
   ```bash
   kubectl get pod webserver -o jsonpath='{.status.containerStatuses[*].name}'
   ```

## Verification & Testing

### Check Sidecar Logs
View the logs being read by the sidecar container:
```bash
kubectl logs webserver -c sidecar-container
```

### Check Nginx Logs
View nginx container logs:
```bash
kubectl logs webserver -c nginx-container
```

### Generate Traffic to Create Logs
Create some access logs by sending requests to nginx:
```bash
# Get Pod IP
kubectl get pod webserver -o wide

# Send test requests (replace POD_IP with actual IP)
kubectl run test-pod --image=busybox -it --rm --restart=Never -- wget -O- http://POD_IP
```

### Describe the Pod
Get detailed information about the Pod:
```bash
kubectl describe pod webserver
```

### Execute Commands Inside Containers
Access nginx container:
```bash
kubectl exec -it webserver -c nginx-container -- /bin/bash
```

Access sidecar container:
```bash
kubectl exec -it webserver -c sidecar-container -- /bin/bash
```

### Check Shared Volume
Verify the shared volume is mounted correctly:
```bash
kubectl exec webserver -c nginx-container -- ls -la /var/log/nginx
kubectl exec webserver -c sidecar-container -- ls -la /var/log/nginx
```

## How It Works

1. **Log Generation**: Nginx writes access and error logs to `/var/log/nginx/access.log` and `/var/log/nginx/error.log`

2. **Shared Storage**: The `shared-logs` emptyDir volume is mounted at `/var/log/nginx` in both containers

3. **Log Reading**: The sidecar container runs a continuous loop that:
   - Reads both log files using `cat`
   - Outputs the content (simulating log shipping)
   - Sleeps for 30 seconds
   - Repeats

4. **Log Shipping**: In production, you would replace the `cat` command with actual log shipping tools like:
   - Fluentd
   - Filebeat
   - Logstash
   - Vector

## Benefits of This Pattern

- **Separation of Concerns**: Each container has a single responsibility
- **Resource Efficiency**: Shared volume eliminates need for persistent storage
- **Flexibility**: Easy to swap log shipping container without affecting nginx
- **Observability**: Last 24 hours of logs available for debugging
- **Scalability**: Pattern can be replicated across multiple Pods

## Cleanup

To remove the Pod:
```bash
kubectl delete pod webserver
```

Or using the manifest:
```bash
kubectl delete -f webserver-pod.yaml
```

## Troubleshooting

### Pod Not Starting
```bash
kubectl describe pod webserver
kubectl get events --sort-by='.lastTimestamp'
```

### Container Crashes
Check logs for the specific container:
```bash
kubectl logs webserver -c nginx-container --previous
kubectl logs webserver -c sidecar-container --previous
```

### Volume Mount Issues
Verify volume mounts:
```bash
kubectl get pod webserver -o yaml | grep -A 10 volumeMounts
```

### No Logs Appearing
1. Generate traffic to create access logs
2. Check if log files exist in the shared volume
3. Verify sidecar container is running

## Production Considerations

For production environments, consider:

1. **Resource Limits**: Add CPU and memory limits
   ```yaml
   resources:
     limits:
       memory: "128Mi"
       cpu: "500m"
     requests:
       memory: "64Mi"
       cpu: "250m"
   ```

2. **Log Rotation**: Implement log rotation to prevent disk space issues

3. **Real Log Shipper**: Replace the simple `cat` command with actual log aggregation tools

4. **Health Checks**: Add liveness and readiness probes

5. **Security**: Run containers with non-root users where possible

## References

- [Kubernetes Logging Architecture](https://kubernetes.io/docs/concepts/cluster-administration/logging/)
- [The Distributed System ToolKit: Patterns for Composite Containers](https://kubernetes.io/blog/2015/06/the-distributed-system-toolkit-patterns/)
- [Sidecar Pattern](https://docs.microsoft.com/en-us/azure/architecture/patterns/sidecar)
