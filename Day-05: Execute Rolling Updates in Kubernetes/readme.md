# Nginx Rolling Update Documentation

## Overview

This document provides comprehensive instructions for performing a rolling update on the `nginx-deployment` application running in the Kubernetes cluster. The update will migrate the application from its current nginx version to `nginx:1.17`.

## Prerequisites

- Access to `jump_host` with `kubectl` configured
- Proper RBAC permissions to update deployments
- Target deployment: `nginx-deployment`
- Target image: `nginx:1.17`

## Quick Start

Execute the rolling update with a single command:

```bash
kubectl set image deployment/nginx-deployment nginx=nginx:1.17 --record
```

Monitor the rollout:

```bash
kubectl rollout status deployment/nginx-deployment
```

## Detailed Procedure

### Step 1: Pre-Update Verification

Before initiating the update, verify the current deployment state:

```bash
# Check deployment status
kubectl get deployment nginx-deployment

# View current image version
kubectl describe deployment nginx-deployment | grep Image

# List current pods
kubectl get pods -l app=nginx
```

### Step 2: Execute Rolling Update

Perform the update using one of the following methods:

**Method 1: Using kubectl set image (Recommended)**

```bash
kubectl set image deployment/nginx-deployment nginx=nginx:1.17 --record
```

**Method 2: Using kubectl patch**

```bash
kubectl patch deployment nginx-deployment -p '{"spec":{"template":{"spec":{"containers":[{"name":"nginx","image":"nginx:1.17"}]}}}}'
```

**Method 3: Using kubectl edit (Interactive)**

```bash
kubectl edit deployment nginx-deployment
# Update the image field to nginx:1.17 in the editor
```

### Step 3: Monitor Rollout Progress

Track the update in real-time:

```bash
# Watch rollout status (blocks until complete)
kubectl rollout status deployment/nginx-deployment

# Watch pods in real-time
kubectl get pods -l app=nginx -w
```

### Step 4: Post-Update Validation

Verify the update completed successfully:

```bash
# Check deployment status
kubectl get deployment nginx-deployment

# Verify image version
kubectl describe deployment nginx-deployment | grep Image

# Confirm all pods are running
kubectl get pods -l app=nginx

# Check pod details
kubectl get pods -o wide
```

Expected output shows all pods in `Running` state with `READY` status `1/1`.

## Rollout Management

### View Rollout History

```bash
kubectl rollout history deployment/nginx-deployment
```

### Pause Rollout

If issues are detected during the update:

```bash
kubectl rollout pause deployment/nginx-deployment
```

### Resume Rollout

After investigating paused rollout:

```bash
kubectl rollout resume deployment/nginx-deployment
```

### Rollback to Previous Version

If the new version causes issues:

```bash
# Rollback to previous revision
kubectl rollout undo deployment/nginx-deployment

# Rollback to specific revision
kubectl rollout undo deployment/nginx-deployment --to-revision=2
```

## Troubleshooting

### Pods Not Starting

Check pod events and logs:

```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

### Rollout Stuck

Check deployment events:

```bash
kubectl describe deployment nginx-deployment
kubectl get events --sort-by=.metadata.creationTimestamp
```

### Image Pull Errors

Verify image availability:

```bash
kubectl describe pod <pod-name> | grep -A 10 Events
```

Common causes:
- Incorrect image name or tag
- Missing image pull secrets
- Registry connectivity issues

## Rolling Update Strategy

The deployment uses Kubernetes' default rolling update strategy:

- **Max Unavailable**: 25% of desired pods
- **Max Surge**: 25% above desired pods

This ensures:
- Zero downtime during updates
- Gradual pod replacement
- Automatic rollback on failures

## Verification Checklist

- [ ] Current deployment status checked
- [ ] Rolling update command executed
- [ ] Rollout status monitored to completion
- [ ] All pods in `Running` state
- [ ] Image version confirmed as `nginx:1.17`
- [ ] Application accessibility tested
- [ ] Rollout history recorded

## Best Practices

1. **Always record changes**: Use `--record` flag to maintain rollout history
2. **Monitor actively**: Watch rollout status during updates
3. **Test thoroughly**: Validate application functionality post-update
4. **Have rollback plan**: Know how to quickly revert if needed
5. **Update during maintenance windows**: Schedule updates during low-traffic periods

## Additional Resources

```bash
# Get deployment YAML
kubectl get deployment nginx-deployment -o yaml

# Get deployment as JSON
kubectl get deployment nginx-deployment -o json

# Export deployment configuration
kubectl get deployment nginx-deployment -o yaml > nginx-deployment-backup.yaml
```

## Support

For issues or questions:
- Check pod logs: `kubectl logs <pod-name>`
- Review cluster events: `kubectl get events`
- Contact Nautilus DevOps team

---

**Last Updated**: October 17, 2025  
**Deployment**: nginx-deployment  
**Target Image**: nginx:1.17  
**Cluster**: Nautilus Kubernetes Cluster
