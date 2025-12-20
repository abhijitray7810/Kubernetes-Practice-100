# Kubernetes XFusion Web Application Deployment

## Overview

This project contains Kubernetes manifests to deploy a web application with persistent storage on the Nautilus Kubernetes cluster. The deployment uses persistent volumes to store application code and exposes the web server through a NodePort service.

## Architecture

The deployment consists of four main components:

- **PersistentVolume (PV)**: Provides 4Gi of storage using hostPath
- **PersistentVolumeClaim (PVC)**: Claims 3Gi of storage from the PV
- **Pod**: Runs Apache HTTP server with mounted persistent storage
- **Service**: Exposes the web application via NodePort 30008

## Prerequisites

- Access to the Nautilus Kubernetes cluster
- `kubectl` configured on jump_host to work with the cluster
- Sufficient permissions to create PV, PVC, Pods, and Services

## Resource Specifications

### PersistentVolume (pv-xfusion)

- **Name**: pv-xfusion
- **Storage Class**: manual
- **Capacity**: 4Gi
- **Access Mode**: ReadWriteOnce
- **Volume Type**: hostPath
- **Path**: /mnt/security

### PersistentVolumeClaim (pvc-xfusion)

- **Name**: pvc-xfusion
- **Storage Class**: manual
- **Requested Storage**: 3Gi
- **Access Mode**: ReadWriteOnce

### Pod (pod-xfusion)

- **Name**: pod-xfusion
- **Container Name**: container-xfusion
- **Image**: httpd:latest
- **Mount Point**: /usr/local/apache2/htdocs (Apache document root)
- **Volume**: Mounted from pvc-xfusion

### Service (web-xfusion)

- **Name**: web-xfusion
- **Type**: NodePort
- **Node Port**: 30008
- **Target Port**: 80
- **Protocol**: TCP

## Deployment Instructions

### Quick Deployment

Deploy all resources with a single command:

```bash
kubectl apply -f xfusion-deployment.yaml
```

### Step-by-Step Verification

1. **Verify PersistentVolume creation:**
   ```bash
   kubectl get pv pv-xfusion
   ```
   Expected status: `Available` (before PVC binding) or `Bound` (after PVC binding)

2. **Verify PersistentVolumeClaim:**
   ```bash
   kubectl get pvc pvc-xfusion
   ```
   Expected status: `Bound`

3. **Verify Pod deployment:**
   ```bash
   kubectl get pod pod-xfusion
   ```
   Expected status: `Running`

4. **Verify Service creation:**
   ```bash
   kubectl get svc web-xfusion
   ```
   You should see the NodePort 30008 listed

### Detailed Status Check

```bash
# Check all resources at once
kubectl get pv,pvc,pod,svc | grep xfusion

# Detailed pod information
kubectl describe pod pod-xfusion

# Check pod logs
kubectl logs pod-xfusion

# Check PVC binding status
kubectl describe pvc pvc-xfusion
```

## Accessing the Application

Once deployed, the web application can be accessed via:

```
http://<NODE_IP>:30008
```

To find the node IP:
```bash
kubectl get nodes -o wide
```

## Testing the Deployment

### Test Web Server Response

```bash
# From within the cluster
kubectl exec -it pod-xfusion -- curl localhost

# From jump_host (replace NODE_IP with actual node IP)
curl http://<NODE_IP>:30008
```

### Test Persistent Storage

```bash
# Create a test file in the mounted volume
kubectl exec -it pod-xfusion -- bash -c "echo 'Hello from XFusion!' > /usr/local/apache2/htdocs/index.html"

# Verify the file via web server
curl http://<NODE_IP>:30008
```

## Troubleshooting

### PVC Not Binding

If the PVC remains in `Pending` state:

```bash
kubectl describe pvc pvc-xfusion
```

Check for:
- Storage class mismatch
- Insufficient storage capacity
- Access mode incompatibility

### Pod Not Starting

If the pod fails to start:

```bash
kubectl describe pod pod-xfusion
kubectl logs pod-xfusion
```

Common issues:
- PVC not bound
- Image pull errors
- Resource constraints

### Service Not Accessible

If you cannot access the service:

```bash
# Check service endpoints
kubectl get endpoints web-xfusion

# Verify pod selector matches
kubectl get pod pod-xfusion --show-labels

# Check if port is listening
kubectl exec -it pod-xfusion -- netstat -tlnp
```

## Cleanup

To remove all deployed resources:

```bash
# Delete all resources
kubectl delete -f xfusion-deployment.yaml

# Or delete individually
kubectl delete service web-xfusion
kubectl delete pod pod-xfusion
kubectl delete pvc pvc-xfusion
kubectl delete pv pv-xfusion
```

**Note**: Deleting the PVC will not automatically delete the PV if it has a `Retain` reclaim policy.

## File Structure

```
.
├── xfusion-deployment.yaml    # Main Kubernetes manifest file
└── README.md                  # This file
```

## Important Notes

- The `/mnt/security` directory on the host node is pre-created and managed by the infrastructure team
- The PV uses `hostPath`, which means the pod will be scheduled on a node where this path exists
- The storage class `manual` means there is no dynamic provisioning; the PV must be manually created
- The PVC requests 3Gi but the PV provides 4Gi, allowing for some overhead
- The Apache document root is mounted at `/usr/local/apache2/htdocs`

## Security Considerations

- The `hostPath` volume type should only be used in controlled environments
- Ensure proper RBAC policies are in place for production deployments
- Consider using network policies to restrict pod communication
- Regularly update the httpd image to patch security vulnerabilities

## Support

For issues or questions:
- Contact the Nautilus DevOps team
- Check Kubernetes cluster logs
- Review pod events: `kubectl describe pod pod-xfusion`

## Version History

- **v1.0**: Initial deployment with persistent storage and NodePort service

---

**Last Updated**: December 2025  
**Maintained by**: Nautilus DevOps Team
