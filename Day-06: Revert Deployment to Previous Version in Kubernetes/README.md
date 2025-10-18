# Kubernetes Deployment Rollback Guide

## Overview

This guide provides instructions for rolling back a Kubernetes deployment to a previous revision. This procedure is useful when a new release introduces bugs or issues that require reverting to a stable version.

## Scenario

The Nautilus DevOps team deployed a new release for an application, but a customer reported a bug related to this release. The team needs to revert to the previous version to resolve the issue.

## Prerequisites

- Access to `jump_host` server
- `kubectl` utility configured to interact with the Kubernetes cluster
- Appropriate permissions to manage deployments

## Deployment Information

- **Deployment Name**: `nginx-deployment`
- **Objective**: Rollback to the previous revision

## Rollback Procedure

### Step 1: Initiate the Rollback

Execute the following command on the jump_host:

```bash
kubectl rollout undo deployment/nginx-deployment
```

This command reverts the deployment to the immediately previous revision.

### Step 2: Monitor the Rollback Progress

Check the status of the rollback operation:

```bash
kubectl rollout status deployment/nginx-deployment
```

Wait until you see a message indicating the rollout has been successfully completed.

### Step 3: Verify the Deployment

Confirm the deployment is running correctly:

```bash
kubectl get deployment nginx-deployment
```

Check the pods status:

```bash
kubectl get pods -l app=nginx
```

*Note: Adjust the label selector based on your deployment's actual labels.*

## Advanced Operations

### View Deployment History

To see all available revisions:

```bash
kubectl rollout history deployment/nginx-deployment
```

### View Specific Revision Details

To see details of a specific revision:

```bash
kubectl rollout history deployment/nginx-deployment --revision=<revision-number>
```

### Rollback to a Specific Revision

If you need to rollback to a specific revision (not just the previous one):

```bash
kubectl rollout undo deployment/nginx-deployment --to-revision=<revision-number>
```

### Pause and Resume Rollouts

To pause a rollout (useful during troubleshooting):

```bash
kubectl rollout pause deployment/nginx-deployment
```

To resume a paused rollout:

```bash
kubectl rollout resume deployment/nginx-deployment
```

## Rollback Mechanism

During a rollback, Kubernetes performs the following actions:

1. Identifies the previous ReplicaSet configuration
2. Updates the deployment specification to match the previous version
3. Creates new pods with the previous configuration
4. Gradually terminates pods running the current (buggy) version
5. Ensures zero-downtime during the transition (rolling update strategy)

## Troubleshooting

### Rollback Fails or Hangs

If the rollback doesn't complete:

```bash
# Check deployment events
kubectl describe deployment nginx-deployment

# Check pod events
kubectl get events --sort-by='.lastTimestamp'

# Check pod logs
kubectl logs <pod-name>
```

### No Previous Revision Available

If there's no previous revision to rollback to:

```bash
kubectl rollout history deployment/nginx-deployment
```

Ensure that revision history is being retained (check `revisionHistoryLimit` in deployment spec).

### Verify Current Revision

To check which revision is currently active:

```bash
kubectl rollout history deployment/nginx-deployment
```

Look for the revision marked as "current" or check the deployment's annotations:

```bash
kubectl get deployment nginx-deployment -o yaml | grep -A 5 annotations
```

## Best Practices

1. **Always test in staging** before deploying to production
2. **Maintain revision history** by setting appropriate `revisionHistoryLimit` (default is 10)
3. **Use descriptive change-cause** annotations to track what changed in each revision:
   ```bash
   kubectl annotate deployment/nginx-deployment kubernetes.io/change-cause="Bug fix for customer issue #123"
   ```
4. **Monitor after rollback** to ensure the previous version resolves the issue
5. **Document incidents** to prevent similar issues in future releases
6. **Consider canary deployments** for safer releases

## Additional Resources

- [Kubernetes Deployments Documentation](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Kubernetes Rolling Updates](https://kubernetes.io/docs/tutorials/kubernetes-basics/update/update-intro/)

## Support

For issues or questions, contact the Nautilus DevOps team.

---

**Last Updated**: October 18, 2025  
**Maintained by**: Nautilus DevOps Team
