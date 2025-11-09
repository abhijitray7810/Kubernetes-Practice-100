# Kubernetes Deployment, Upgrade, and Rollback Testing

## Overview
This guide provides instructions for testing deployment updates and rollbacks in the Dev environment before production deployment. The test includes creating a deployment, upgrading it, and performing a rollback to identify potential risks.

## Prerequisites
- Access to `jump_host` with `kubectl` configured
- Kubernetes cluster access
- Permissions to create namespaces, deployments, and services

## Task Objectives

1. Create a namespace `xfusion` with an httpd deployment
2. Upgrade the deployment to a newer version using rolling update
3. Rollback to the original version

## Deployment Specifications

| Component | Value |
|-----------|-------|
| Namespace | `xfusion` |
| Deployment Name | `httpd-deploy` |
| Container Name | `httpd` |
| Initial Image | `httpd:2.4.25` |
| Upgrade Image | `httpd:2.4.43` |
| Replicas | `2` |
| Update Strategy | `RollingUpdate` |
| Max Surge | `1` |
| Max Unavailable | `2` |
| Service Name | `httpd-service` |
| Service Type | `NodePort` |
| Node Port | `30008` |

## Step-by-Step Execution

### Step 1: Create Namespace and Initial Deployment

```bash
# Create the namespace
kubectl create namespace xfusion

# Create the deployment with initial image
kubectl create deployment httpd-deploy \
  --image=httpd:2.4.25 \
  --replicas=2 \
  --namespace=xfusion

# Configure rolling update strategy
kubectl patch deployment httpd-deploy -n xfusion -p '{
  "spec": {
    "strategy": {
      "type": "RollingUpdate",
      "rollingUpdate": {
        "maxSurge": 1,
        "maxUnavailable": 2
      }
    }
  }
}'

# Create NodePort service
kubectl expose deployment httpd-deploy \
  --name=httpd-service \
  --type=NodePort \
  --port=80 \
  --target-port=80 \
  --namespace=xfusion

# Set the specific nodePort
kubectl patch service httpd-service -n xfusion -p '{
  "spec": {
    "ports": [{
      "port": 80,
      "targetPort": 80,
      "nodePort": 30008
    }]
  }
}'
```

**Verification:**
```bash
kubectl get all -n xfusion
kubectl rollout status deployment/httpd-deploy -n xfusion
kubectl describe deployment httpd-deploy -n xfusion | grep Image
```

### Step 2: Upgrade Deployment

```bash
# Upgrade to httpd:2.4.43
kubectl set image deployment/httpd-deploy \
  httpd=httpd:2.4.43 \
  -n xfusion \
  --record

# Monitor the rolling update
kubectl rollout status deployment/httpd-deploy -n xfusion

# Watch pods during update (optional)
kubectl get pods -n xfusion -w
```

**Verification:**
```bash
kubectl get deployments -n xfusion
kubectl get pods -n xfusion
kubectl describe deployment httpd-deploy -n xfusion | grep Image
```

### Step 3: Rollback to Previous Version

```bash
# View rollout history
kubectl rollout history deployment/httpd-deploy -n xfusion

# Rollback to previous version
kubectl rollout undo deployment/httpd-deploy -n xfusion

# Monitor the rollback
kubectl rollout status deployment/httpd-deploy -n xfusion
```

**Verification:**
```bash
kubectl get pods -n xfusion
kubectl describe deployment httpd-deploy -n xfusion | grep Image
kubectl rollout history deployment/httpd-deploy -n xfusion
```

## Alternative: Using YAML Files

Create a file named `httpd-deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: httpd-deploy
  namespace: xfusion
spec:
  replicas: 2
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 2
  selector:
    matchLabels:
      app: httpd
  template:
    metadata:
      labels:
        app: httpd
    spec:
      containers:
      - name: httpd
        image: httpd:2.4.25
        ports:
        - containerPort: 80
```

Create a file named `httpd-service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: httpd-service
  namespace: xfusion
spec:
  type: NodePort
  selector:
    app: httpd
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30008
```

Apply the configurations:
```bash
kubectl create namespace xfusion
kubectl apply -f httpd-deployment.yaml
kubectl apply -f httpd-service.yaml
```

## Useful Commands

### Check Deployment Status
```bash
kubectl get deployments -n xfusion
kubectl describe deployment httpd-deploy -n xfusion
```

### Check Pods
```bash
kubectl get pods -n xfusion
kubectl describe pod <pod-name> -n xfusion
```

### Check Service
```bash
kubectl get svc -n xfusion
kubectl describe svc httpd-service -n xfusion
```

### View Rollout History
```bash
kubectl rollout history deployment/httpd-deploy -n xfusion
kubectl rollout history deployment/httpd-deploy -n xfusion --revision=2
```

### Check Specific Revision Details
```bash
kubectl rollout history deployment/httpd-deploy -n xfusion --revision=1
kubectl rollout history deployment/httpd-deploy -n xfusion --revision=2
```

## Important Notes

⚠️ **Critical**: Use the exact image versions specified:
- Initial deployment: `httpd:2.4.25`
- Upgrade: `httpd:2.4.43`

Using wrong images will distort the revision history and cause task failure.

⚠️ **Sequence Matters**: Follow the steps in order:
1. Create with `httpd:2.4.25`
2. Upgrade to `httpd:2.4.43`
3. Rollback to `httpd:2.4.25`

## Expected Results

### After Step 1
- Namespace `xfusion` created
- 2 pods running with `httpd:2.4.25`
- Service accessible on NodePort 30008
- Revision 1 in history

### After Step 2
- All pods updated to `httpd:2.4.43`
- Rolling update completed successfully
- Revision 2 in history

### After Step 3
- All pods rolled back to `httpd:2.4.25`
- Rollback completed successfully
- Revision 3 in history (rollback creates a new revision)

## Troubleshooting

### Pods not starting
```bash
kubectl describe pod <pod-name> -n xfusion
kubectl logs <pod-name> -n xfusion
```

### Rollout stuck
```bash
kubectl rollout status deployment/httpd-deploy -n xfusion
kubectl get events -n xfusion --sort-by='.lastTimestamp'
```

### Service not accessible
```bash
kubectl get endpoints httpd-service -n xfusion
kubectl describe svc httpd-service -n xfusion
```

## Cleanup (Optional)

To clean up after testing:
```bash
kubectl delete namespace xfusion
```

This will remove all resources created in the `xfusion` namespace.

## Success Criteria

- ✅ Namespace created successfully
- ✅ Initial deployment with 2 replicas running
- ✅ Service accessible on NodePort 30008
- ✅ Rolling update completed without errors
- ✅ All pods updated to new version
- ✅ Rollback completed successfully
- ✅ Pods reverted to original version
- ✅ Revision history shows all changes

## References

- [Kubernetes Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Rolling Updates](https://kubernetes.io/docs/tutorials/kubernetes-basics/update/update-intro/)
- [Rollback](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-back-a-deployment)
