# Webserver Pod with Sidecar Log Aggregation

## Overview

This project implements a Kubernetes Pod using the **Sidecar Pattern** for log aggregation. The Pod runs an nginx web server alongside a sidecar container that continuously reads and ships the access and error logs.

## Architecture

The solution follows the **separation of concerns** principle:

- **nginx-container**: Serves web pages (does one thing well)
- **sidecar-container**: Aggregates and ships logs (specialized task)
- **shared-logs volume**: Enables log sharing between containers

## Components

### Pod: `webserver`
Contains two containers sharing an emptyDir volume for log communication.

### Containers

1. **nginx-container**
   - Image: `nginx:latest`
   - Purpose: Web server
   - Volume Mount: `/var/log/nginx`

2. **sidecar-container**
   - Image: `ubuntu:latest`
   - Purpose: Log aggregation
   - Volume Mount: `/var/log/nginx`
   - Command: Reads access.log and error.log every 30 seconds

### Volume

- **shared-logs** (emptyDir)
  - Temporary storage for the last 24 hours of logs
  - Shared between both containers
  - Automatically cleaned up when Pod is deleted

## Prerequisites

- Kubernetes cluster access
- `kubectl` configured on jump_host
- Appropriate permissions to create Pods

## Deployment

### Step 1: Apply the Manifest

```bash
kubectl apply -f webserver-pod.yaml
```

### Step 2: Verify Deployment

```bash
# Check pod status
kubectl get pod webserver

# Check both containers are running
kubectl get pod webserver -o jsonpath='{.status.containerStatuses[*].name}' && echo
```

Expected output: `nginx-container sidecar-container`

### Step 3: Verify Container Status

```bash
# Detailed pod information
kubectl describe pod webserver
```

## Usage

### View Aggregated Logs

```bash
# View sidecar logs (shows aggregated access and error logs)
kubectl logs webserver -c sidecar-container
```

### Follow Logs in Real-Time

```bash
# Stream logs continuously
kubectl logs webserver -c sidecar-container -f
```

### Access Nginx Container

```bash
# Execute commands in nginx container
kubectl exec -it webserver -c nginx-container -- /bin/bash
```

### Access Sidecar Container

```bash
# Execute commands in sidecar container
kubectl exec -it webserver -c sidecar-container -- /bin/bash
```

### Test Nginx Web Server

```bash
# Get Pod IP
kubectl get pod webserver -o wide

# Test from another pod or node
curl http://<POD_IP>
```

## Log Retention

- Logs are stored in the emptyDir volume
- Available for the last 24 hours (as per requirement)
- Logs are ephemeral and deleted when the Pod is removed
- Not suitable for long-term log persistence

## Monitoring

### Check Container Health

```bash
# Check if both containers are ready
kubectl get pod webserver -o jsonpath='{range .status.containerStatuses[*]}{.name}{"\t"}{.ready}{"\n"}{end}'
```

### View Events

```bash
# Troubleshoot any issues
kubectl get events --field-selector involvedObject.name=webserver
```

## Troubleshooting

### Pod Not Starting

```bash
# Check pod events
kubectl describe pod webserver

# Check container logs
kubectl logs webserver -c nginx-container
kubectl logs webserver -c sidecar-container
```

### Sidecar Container Crashing

The sidecar may fail initially if nginx hasn't created log files yet. This is normal behavior and the container will retry.

```bash
# Check restart count
kubectl get pod webserver -o jsonpath='{.status.containerStatuses[?(@.name=="sidecar-container")].restartCount}'
```

### No Logs Appearing

```bash
# Generate some traffic to create access logs
POD_IP=$(kubectl get pod webserver -o jsonpath='{.status.podIP}')
curl http://$POD_IP

# Wait 30 seconds and check sidecar logs
kubectl logs webserver -c sidecar-container
```

## Cleanup

```bash
# Delete the pod
kubectl delete pod webserver

# Verify deletion
kubectl get pod webserver
```

## Benefits of Sidecar Pattern

1. **Separation of Concerns**: Each container has a single responsibility
2. **Modularity**: Components can be updated independently
3. **Reusability**: Sidecar container can be reused with other applications
4. **Resource Efficiency**: Shared volume eliminates need for network communication
5. **Co-location**: Both containers run on same Pod, ensuring they're always together

## Design Decisions

### Why emptyDir?

- Logs are not critical enough for persistent storage
- Only need last 24 hours of logs
- Automatically cleaned up with Pod deletion
- Fast and efficient for temporary data

### Why 30-Second Interval?

- Balance between real-time monitoring and resource usage
- Can be adjusted based on requirements
- Prevents overwhelming the log aggregation service

## Future Enhancements

- Add log shipping to external service (Elasticsearch, Splunk, etc.)
- Implement log rotation for better disk management
- Add filters to parse and format logs
- Include metrics collection alongside logs
- Add resource limits and requests for both containers

## License

This configuration is provided as-is for educational and production use.

## Support

For issues or questions, please consult the Kubernetes documentation or contact your DevOps team.
