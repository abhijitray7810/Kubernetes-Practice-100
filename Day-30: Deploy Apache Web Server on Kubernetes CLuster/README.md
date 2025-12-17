# Nautilus Apache Web Server Deployment

This repository contains Kubernetes configuration files for deploying the Apache HTTP Server (httpd) application on the Nautilus Kubernetes cluster.

## Overview

The deployment consists of three main Kubernetes resources:
- **Namespace**: Isolated environment for the application
- **Deployment**: Apache web server with 2 replicas for high availability
- **Service**: NodePort service to expose the application externally

## Prerequisites

- Access to the Nautilus Kubernetes cluster
- `kubectl` utility configured on jump_host
- Appropriate permissions to create namespaces, deployments, and services

## Architecture

```
┌─────────────────────────────────────────────┐
│  httpd-namespace-nautilus (Namespace)       │
│                                             │
│  ┌───────────────────────────────────────┐ │
│  │  httpd-deployment-nautilus            │ │
│  │  (Deployment)                         │ │
│  │                                       │ │
│  │  ┌─────────────┐  ┌─────────────┐   │ │
│  │  │   Pod 1     │  │   Pod 2     │   │ │
│  │  │ httpd:latest│  │ httpd:latest│   │ │
│  │  │   Port 80   │  │   Port 80   │   │ │
│  │  └─────────────┘  └─────────────┘   │ │
│  │         ▲                ▲           │ │
│  └─────────┼────────────────┼───────────┘ │
│            │                │             │
│  ┌─────────┴────────────────┴───────────┐ │
│  │  httpd-service-nautilus              │ │
│  │  (NodePort Service)                  │ │
│  │  External Port: 30004                │ │
│  └──────────────────────────────────────┘ │
└─────────────────────────────────────────────┘
```

## Resource Specifications

### Namespace
- **Name**: `httpd-namespace-nautilus`
- **Purpose**: Provides resource isolation and organization

### Deployment
- **Name**: `httpd-deployment-nautilus`
- **Namespace**: `httpd-namespace-nautilus`
- **Image**: `httpd:latest`
- **Replicas**: 2
- **Container Port**: 80
- **Labels**: `app: httpd-nautilus`

### Service
- **Name**: `httpd-service-nautilus`
- **Namespace**: `httpd-namespace-nautilus`
- **Type**: NodePort
- **Port**: 80 (internal)
- **NodePort**: 30004 (external)
- **Protocol**: TCP

## Deployment Instructions

### Step 1: Save the Configuration

Save the YAML configuration to a file named `httpd-nautilus.yaml`:

```bash
vi httpd-nautilus.yaml
```

### Step 2: Apply the Configuration

Deploy all resources to the Kubernetes cluster:

```bash
kubectl apply -f httpd-nautilus.yaml
```

**Expected Output:**
```
namespace/httpd-namespace-nautilus created
deployment.apps/httpd-deployment-nautilus created
service/httpd-service-nautilus created
```

### Step 3: Verify the Deployment

#### Check Namespace
```bash
kubectl get namespace httpd-namespace-nautilus
```

#### Check Deployment Status
```bash
kubectl get deployment -n httpd-namespace-nautilus
```

**Expected Output:**
```
NAME                        READY   UP-TO-DATE   AVAILABLE   AGE
httpd-deployment-nautilus   2/2     2            2           1m
```

#### Check Pod Status
```bash
kubectl get pods -n httpd-namespace-nautilus
```

**Expected Output:**
```
NAME                                        READY   STATUS    RESTARTS   AGE
httpd-deployment-nautilus-xxxxxxxxx-xxxxx   1/1     Running   0          1m
httpd-deployment-nautilus-xxxxxxxxx-xxxxx   1/1     Running   0          1m
```

#### Check Service
```bash
kubectl get service -n httpd-namespace-nautilus
```

**Expected Output:**
```
NAME                     TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
httpd-service-nautilus   NodePort   10.xxx.xxx.xxx  <none>        80:30004/TCP   1m
```

### Step 4: Access the Application

#### Get Node IP Address
```bash
kubectl get nodes -o wide
```

#### Access the Application
Open a web browser or use curl:

```bash
# Using curl
curl http://<node-ip>:30004

# Using wget
wget http://<node-ip>:30004

# Using browser
http://<node-ip>:30004
```

## Monitoring and Troubleshooting

### View Pod Logs
```bash
# Get pod names
kubectl get pods -n httpd-namespace-nautilus

# View logs for a specific pod
kubectl logs <pod-name> -n httpd-namespace-nautilus

# Follow logs in real-time
kubectl logs -f <pod-name> -n httpd-namespace-nautilus
```

### Describe Resources
```bash
# Describe deployment
kubectl describe deployment httpd-deployment-nautilus -n httpd-namespace-nautilus

# Describe service
kubectl describe service httpd-service-nautilus -n httpd-namespace-nautilus

# Describe pod
kubectl describe pod <pod-name> -n httpd-namespace-nautilus
```

### Check Events
```bash
kubectl get events -n httpd-namespace-nautilus --sort-by='.lastTimestamp'
```

### Execute Commands in Pod
```bash
kubectl exec -it <pod-name> -n httpd-namespace-nautilus -- /bin/bash
```

## Scaling the Deployment

### Scale Up
```bash
kubectl scale deployment httpd-deployment-nautilus --replicas=3 -n httpd-namespace-nautilus
```

### Scale Down
```bash
kubectl scale deployment httpd-deployment-nautilus --replicas=1 -n httpd-namespace-nautilus
```

## Updating the Deployment

### Update Image Version
```bash
kubectl set image deployment/httpd-deployment-nautilus httpd=httpd:2.4 -n httpd-namespace-nautilus
```

### Check Rollout Status
```bash
kubectl rollout status deployment/httpd-deployment-nautilus -n httpd-namespace-nautilus
```

### Rollback Deployment
```bash
kubectl rollout undo deployment/httpd-deployment-nautilus -n httpd-namespace-nautilus
```

## Cleanup

### Delete All Resources
```bash
kubectl delete -f httpd-nautilus.yaml
```

### Delete Namespace Only
```bash
kubectl delete namespace httpd-namespace-nautilus
```

**Note**: Deleting the namespace will automatically delete all resources within it.

## Common Issues and Solutions

### Issue 1: Pods Not Starting
**Symptom**: Pods stuck in `Pending` or `ImagePullBackOff` state

**Solution**:
```bash
# Check pod details
kubectl describe pod <pod-name> -n httpd-namespace-nautilus

# Check if image is accessible
kubectl get events -n httpd-namespace-nautilus
```

### Issue 2: Service Not Accessible
**Symptom**: Cannot access application via NodePort

**Solution**:
- Verify service is running: `kubectl get svc -n httpd-namespace-nautilus`
- Check firewall rules allow traffic on port 30004
- Ensure you're using the correct node IP address
- Verify pods are running and ready

### Issue 3: Insufficient Resources
**Symptom**: Pods stuck in `Pending` state with scheduling errors

**Solution**:
```bash
# Check node resources
kubectl top nodes

# Check pod resource requests
kubectl describe pod <pod-name> -n httpd-namespace-nautilus
```

## Best Practices

1. **Resource Limits**: Consider adding resource requests and limits to prevent resource exhaustion
2. **Health Checks**: Add liveness and readiness probes for better reliability
3. **Image Tags**: Use specific version tags instead of `latest` in production
4. **Security**: Run containers as non-root user when possible
5. **Monitoring**: Set up monitoring and alerting for the application
6. **Backup**: Regularly backup your configuration files

## Additional Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Apache HTTP Server Documentation](https://httpd.apache.org/docs/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

## Support

For issues or questions, contact the Nautilus DevOps team.

---

**Version**: 1.0  
**Last Updated**: December 2024  
**Maintained by**: Nautilus DevOps Team
