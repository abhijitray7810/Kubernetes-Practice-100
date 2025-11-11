# Grafana Kubernetes Deployment - Nautilus DevOps

## Overview
This repository contains Kubernetes manifests for deploying Grafana on a Kubernetes cluster for the Nautilus DevOps team. Grafana will be used to collect and analyze analytics from various applications.

## Prerequisites
- Kubernetes cluster is up and running
- `kubectl` CLI tool configured on jump_host
- Access to the Kubernetes cluster with appropriate permissions

## Architecture

### Components
1. **Deployment**: `grafana-deployment-nautilus`
   - Runs Grafana application
   - Uses official Grafana Docker image
   - Single replica configuration

2. **Service**: `grafana-service-nautilus`
   - NodePort type service
   - Exposes Grafana on port 32000

## Configuration Details

### Deployment Specifications
- **Name**: grafana-deployment-nautilus
- **Image**: grafana/grafana:latest
- **Container Port**: 3000
- **Replicas**: 1
- **Default Credentials**: admin/admin

### Service Specifications
- **Name**: grafana-service-nautilus
- **Type**: NodePort
- **Port**: 3000 (internal)
- **TargetPort**: 3000 (container)
- **NodePort**: 32000 (external access)

### Resource Limits
- **Requests**:
  - Memory: 128Mi
  - CPU: 100m
- **Limits**:
  - Memory: 512Mi
  - CPU: 500m

## Deployment Instructions

### Step 1: Apply the Configuration
```bash
kubectl apply -f grafana-deployment.yaml
```

### Step 2: Verify Deployment
```bash
# Check deployment status
kubectl get deployment grafana-deployment-nautilus

# Check if pods are running
kubectl get pods -l app=grafana

# Verify service creation
kubectl get svc grafana-service-nautilus
```

### Step 3: Wait for Pod to be Ready
```bash
# Watch pod status
kubectl get pods -l app=grafana -w

# Check pod logs if needed
kubectl logs -l app=grafana
```

## Accessing Grafana

### Get Node IP
```bash
kubectl get nodes -o wide
```

### Access URL
Open your browser and navigate to:
```
http://<NODE_IP>:32000
```

### Login Credentials
- **Username**: admin
- **Password**: admin

**Note**: You will be prompted to change the password on first login, but no configuration changes are required for this setup.

## Troubleshooting

### Pod Not Starting
```bash
# Check pod details
kubectl describe pod -l app=grafana

# Check pod logs
kubectl logs -l app=grafana
```

### Service Not Accessible
```bash
# Verify service endpoints
kubectl get endpoints grafana-service-nautilus

# Check service details
kubectl describe svc grafana-service-nautilus

# Verify NodePort is listening
kubectl get svc grafana-service-nautilus -o yaml
```

### Check Deployment Status
```bash
# Get deployment details
kubectl describe deployment grafana-deployment-nautilus

# Check replica set
kubectl get rs -l app=grafana
```

## Cleanup

To remove the Grafana deployment and service:

```bash
kubectl delete -f grafana-deployment.yaml
```

Or individually:
```bash
kubectl delete deployment grafana-deployment-nautilus
kubectl delete service grafana-service-nautilus
```

## Common Operations

### Scale Deployment
```bash
kubectl scale deployment grafana-deployment-nautilus --replicas=2
```

### Update Image
```bash
kubectl set image deployment/grafana-deployment-nautilus grafana=grafana/grafana:9.5.0
```

### Restart Pods
```bash
kubectl rollout restart deployment grafana-deployment-nautilus
```

### View Logs
```bash
# View current logs
kubectl logs -l app=grafana

# Follow logs
kubectl logs -l app=grafana -f

# View logs from specific pod
kubectl logs <pod-name>
```

## File Structure
```
.
├── grafana-deployment.yaml    # Kubernetes manifests
└── README.md                  # This file
```

## Notes
- The deployment uses default Grafana configurations
- No persistent storage is configured (data will be lost on pod restart)
- For production use, consider adding:
  - Persistent Volume Claims (PVC) for data persistence
  - ConfigMaps for custom Grafana configuration
  - Secrets for sensitive credentials
  - Ingress for better routing
  - Resource quotas and limits

## Support
For issues related to:
- **Kubernetes**: Contact your cluster administrator
- **Grafana**: Refer to [Grafana Documentation](https://grafana.com/docs/)
- **Deployment**: Contact Nautilus DevOps team

## Version Information
- Kubernetes API Version: apps/v1
- Grafana Image: grafana/grafana:latest
- Service API Version: v1
