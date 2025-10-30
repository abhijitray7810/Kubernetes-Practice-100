# Nginx Rolling Update - Deployment Guide

## Overview

This guide documents the process of performing a rolling update for the `nginx-deployment` application running on the Kubernetes cluster, updating from the current version to `nginx:1.18`.

## Prerequisites

- Access to `jump_host` with `kubectl` configured
- Kubernetes cluster access with appropriate permissions
- Deployment name: `nginx-deployment`
- Target image: `nginx:1.18`

## Rolling Update Procedure

### Step 1: Check Current Deployment Status

Before performing the update, verify the current state of the deployment:

```bash
# View deployment details
kubectl get deployment nginx-deployment

# Get detailed information
kubectl describe deployment nginx-deployment

# Check current pods
kubectl get pods
```

### Step 2: Identify Container Name

Determine the container name within the deployment:

```bash
kubectl get deployment nginx-deployment -o jsonpath='{.spec.template.spec.containers[*].name}'
```

### Step 3: Execute Rolling Update

Perform the rolling update using the `kubectl set image` command:

```bash
# Replace <container-name> with the actual container name from Step 2
kubectl set image deployment/nginx-deployment <container-name>=nginx:1.18
```

**Common container names:**
- `nginx`
- `nginx-container`
- `web`

**Example:**
```bash
kubectl set image deployment/nginx-deployment nginx=nginx:1.18
```

### Step 4: Monitor Rollout Progress

Watch the rollout status in real-time:

```bash
kubectl rollout status deployment/nginx-deployment
```

This command will display progress and wait until the rollout completes successfully.

### Step 5: Verify Update Success

Confirm all pods are operational with the new image:

```bash
# Check pod status
kubectl get pods

# Verify running pods with labels (adjust label selector as needed)
kubectl get pods -l app=nginx

# Confirm image version
kubectl get pods -o jsonpath='{.items[*].spec.containers[*].image}' | tr ' ' '\n'

# Detailed deployment verification
kubectl describe deployment nginx-deployment | grep Image
```

## Alternative Update Methods

### Method 1: Using kubectl edit

Manually edit the deployment manifest:

```bash
kubectl edit deployment nginx-deployment
```

Locate the `image` field under `spec.template.spec.containers` and change it to `nginx:1.18`. Save and exit.

### Method 2: Using kubectl patch

Apply a patch to update the image:

```bash
kubectl patch deployment nginx-deployment -p '{"spec":{"template":{"spec":{"containers":[{"name":"<container-name>","image":"nginx:1.18"}]}}}}'
```

### Method 3: Apply Updated YAML

If you have the deployment YAML file:

```bash
# Edit the YAML file to update the image version
vi nginx-deployment.yaml

# Apply the changes
kubectl apply -f nginx-deployment.yaml
```

## Rollout Management

### View Rollout History

```bash
kubectl rollout history deployment/nginx-deployment
```

### Pause Rollout

If you need to temporarily pause the rollout:

```bash
kubectl rollout pause deployment/nginx-deployment
```

### Resume Rollout

To resume a paused rollout:

```bash
kubectl rollout resume deployment/nginx-deployment
```

### Rollback to Previous Version

If issues occur, rollback to the previous version:

```bash
# Rollback to previous revision
kubectl rollout undo deployment/nginx-deployment

# Rollback to specific revision
kubectl rollout undo deployment/nginx-deployment --to-revision=<revision-number>
```

## Verification Checklist

After completing the rolling update, verify the following:

- [ ] All pods are in `Running` state
- [ ] All pods are using the `nginx:1.18` image
- [ ] Deployment shows correct number of ready replicas
- [ ] Application is accessible and functioning correctly
- [ ] No error logs in pods

**Verification commands:**

```bash
# Check all resources
kubectl get all

# Check pod health
kubectl get pods -o wide

# View pod logs
kubectl logs -l app=nginx --tail=50

# Test application endpoint (if service exists)
kubectl get svc
```

## Troubleshooting

### Pods Not Starting

Check pod events and logs:

```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

### Image Pull Errors

Verify image availability:

```bash
# Check image pull status
kubectl get pods
kubectl describe pod <pod-name> | grep -A 10 Events
```

### Rollout Stuck

If the rollout appears stuck:

```bash
# Check rollout status
kubectl rollout status deployment/nginx-deployment

# View detailed events
kubectl get events --sort-by=.metadata.creationTimestamp
```

## Rolling Update Strategy

The deployment uses a rolling update strategy with the following default behavior:

- **Max Surge**: Maximum number of pods that can be created over the desired number
- **Max Unavailable**: Maximum number of pods that can be unavailable during the update

To view current strategy settings:

```bash
kubectl get deployment nginx-deployment -o jsonpath='{.spec.strategy}'
```

## Best Practices

1. **Always check current status** before making changes
2. **Monitor the rollout** to catch issues early
3. **Verify pod health** after updates complete
4. **Keep rollout history** for easy rollbacks
5. **Test in non-production** environments first
6. **Document changes** for team awareness

## Additional Resources

- [Kubernetes Deployments Documentation](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Rolling Update Strategy](https://kubernetes.io/docs/tutorials/kubernetes-basics/update/update-intro/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

## Notes

- The `kubectl` utility on `jump_host` is pre-configured to work with the Kubernetes cluster
- Rolling updates ensure zero-downtime deployments
- Old ReplicaSets are retained for rollback capability
- Always verify application functionality after updates

---

**Last Updated**: October 30, 2025  
**Target Image**: nginx:1.18  
**Deployment**: nginx-deployment
