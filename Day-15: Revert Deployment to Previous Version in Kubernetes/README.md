# Kubernetes Deployment Rollback Guide

## Overview

This document provides instructions for rolling back the `nginx-deployment` to a previous revision after a bug was reported in the latest release.

## Prerequisites

- Access to `jump_host` with `kubectl` configured
- Sufficient permissions to manage deployments in the Kubernetes cluster
- The deployment `nginx-deployment` exists in the cluster

## Problem Statement

The Nautilus DevOps team deployed a new release that contains a bug reported by a customer. The team needs to quickly revert to the previous stable version to minimize customer impact.

## Solution: Rollback to Previous Revision

### Quick Rollback Command

Execute the following command from `jump_host`:

```bash
kubectl rollout undo deployment/nginx-deployment
```

This command will automatically rollback the deployment to the immediately previous revision.

### Step-by-Step Process

1. **Verify Current Deployment Status**
   ```bash
   kubectl get deployment nginx-deployment
   kubectl describe deployment nginx-deployment
   ```

2. **Check Rollout History**
   ```bash
   kubectl rollout history deployment/nginx-deployment
   ```
   
   This shows all previous revisions with their change causes.

3. **Initiate Rollback**
   ```bash
   kubectl rollout undo deployment/nginx-deployment
   ```

4. **Monitor Rollback Progress**
   ```bash
   kubectl rollout status deployment/nginx-deployment
   ```
   
   Wait until you see: `deployment "nginx-deployment" successfully rolled out`

5. **Verify Pods are Running**
   ```bash
   kubectl get pods
   kubectl get pods -l app=nginx  # if using label selector
   ```

6. **Confirm Application Health**
   - Test the application endpoint
   - Verify customer-reported bug is resolved
   - Check application logs if needed:
     ```bash
     kubectl logs -l app=nginx --tail=50
     ```

### Rollback to Specific Revision

If you need to rollback to a specific revision (not just the previous one):

```bash
# View detailed history with revision numbers
kubectl rollout history deployment/nginx-deployment

# Rollback to specific revision
kubectl rollout undo deployment/nginx-deployment --to-revision=<revision-number>
```

**Example:**
```bash
kubectl rollout undo deployment/nginx-deployment --to-revision=3
```

## What Happens During Rollback

1. Kubernetes creates new pods using the previous revision's configuration
2. Old pods are terminated gradually following the deployment strategy
3. The rollout follows the defined `maxSurge` and `maxUnavailable` settings
4. Zero-downtime rollback is maintained (with default RollingUpdate strategy)
5. A new revision is created in the history

## Verification Checklist

- [ ] Rollback command executed successfully
- [ ] All pods are in `Running` state
- [ ] Application is accessible and responding
- [ ] Customer-reported bug is no longer reproducible
- [ ] No error logs in pod logs
- [ ] Deployment shows correct revision number

## Troubleshooting

### Rollback Fails or Hangs

```bash
# Check pod status and events
kubectl get pods
kubectl describe pod <pod-name>

# Check deployment events
kubectl describe deployment nginx-deployment

# View detailed rollout status
kubectl rollout status deployment/nginx-deployment -w
```

### Pause and Resume Rollout

If you need to pause the rollout:
```bash
kubectl rollout pause deployment/nginx-deployment
```

Resume when ready:
```bash
kubectl rollout resume deployment/nginx-deployment
```

### Cancel Rollback

If you need to stop the rollback:
```bash
kubectl rollout undo deployment/nginx-deployment --to-revision=<current-bad-revision>
```

## Best Practices

1. **Always check rollout history** before performing rollback
2. **Monitor the rollback process** to ensure smooth transition
3. **Test the application** after rollback completion
4. **Document the incident** and root cause analysis
5. **Keep revision history** - avoid deleting old ReplicaSets
6. **Set revision history limit** appropriately:
   ```yaml
   spec:
     revisionHistoryLimit: 10
   ```

## Post-Rollback Actions

1. ✅ Verify application functionality
2. ✅ Inform stakeholders about the rollback
3. ✅ Investigate root cause of the bug
4. ✅ Fix the bug in the codebase
5. ✅ Test thoroughly before next deployment
6. ✅ Update deployment documentation if needed

## Additional Commands Reference

```bash
# View deployment details
kubectl get deployment nginx-deployment -o yaml

# Check ReplicaSets
kubectl get rs

# View events
kubectl get events --sort-by='.lastTimestamp'

# Scale deployment manually if needed
kubectl scale deployment nginx-deployment --replicas=<number>
```

## Support

For issues or questions, contact the Nautilus DevOps team.

## Documentation

- [Kubernetes Deployments Documentation](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [kubectl Rollout Commands](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#rollout)
