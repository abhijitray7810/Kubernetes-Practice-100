# Kubernetes Deployment and Service Update Guide

## Overview
This guide provides step-by-step instructions to update the `nginx-deployment` and `nginx-service` in your Kubernetes cluster without deleting existing resources.

## Prerequisites
- Access to `jump_host` with `kubectl` configured
- Sufficient permissions to modify deployments and services
- Existing resources: `nginx-deployment` and `nginx-service`

## Required Changes

| Component | Parameter | Current Value | New Value |
|-----------|-----------|---------------|-----------|
| Service | NodePort | 30008 | 32165 |
| Deployment | Replicas | 1 | 5 |
| Deployment | Image | nginx:1.19 | nginx:latest |

## Quick Start

### Method 1: Individual Commands (Recommended)

```bash
# Step 1: Update Service NodePort
kubectl patch service nginx-service -p '{"spec":{"ports":[{"port":80,"nodePort":32165,"targetPort":80}]}}'

# Step 2: Scale Deployment Replicas
kubectl scale deployment nginx-deployment --replicas=5

# Step 3: Update Container Image
kubectl set image deployment/nginx-deployment nginx=nginx:latest --record

# Step 4: Monitor Rollout
kubectl rollout status deployment/nginx-deployment
```

### Method 2: Using kubectl edit

```bash
# Edit Service
kubectl edit service nginx-service
# Find 'nodePort: 30008' and change to 'nodePort: 32165'
# Save and exit

# Edit Deployment
kubectl edit deployment nginx-deployment
# Find 'replicas: 1' and change to 'replicas: 5'
# Find 'image: nginx:1.19' and change to 'image: nginx:latest'
# Save and exit
```

### Method 3: Automated Script

Run the provided bash script:

```bash
chmod +x update-k8s.sh
./update-k8s.sh
```

## Detailed Steps

### 1. Verify Current Configuration

Before making changes, check the current state:

```bash
# Check deployment
kubectl get deployment nginx-deployment -o wide
kubectl describe deployment nginx-deployment

# Check service
kubectl get service nginx-service -o wide
kubectl describe service nginx-service

# Check pods
kubectl get pods -l app=nginx
```

### 2. Update Service NodePort

Change the NodePort from 30008 to 32165:

```bash
kubectl patch service nginx-service -p '{"spec":{"ports":[{"port":80,"nodePort":32165,"targetPort":80}]}}'
```

**Verify:**
```bash
kubectl get service nginx-service
# Should show NodePort as 32165
```

### 3. Scale Deployment Replicas

Increase replicas from 1 to 5:

```bash
kubectl scale deployment nginx-deployment --replicas=5
```

**Verify:**
```bash
kubectl get deployment nginx-deployment
# READY column should show 5/5

kubectl get pods -l app=nginx
# Should list 5 pods
```

### 4. Update Container Image

Update from nginx:1.19 to nginx:latest:

```bash
kubectl set image deployment/nginx-deployment nginx=nginx:latest --record
```

**Note:** Replace `nginx` with the actual container name if different.

**Verify:**
```bash
kubectl rollout status deployment/nginx-deployment
kubectl describe deployment nginx-deployment | grep Image
```

### 5. Monitor Rollout

Watch the rolling update progress:

```bash
# Watch rollout status
kubectl rollout status deployment/nginx-deployment

# Watch pods being updated
kubectl get pods -l app=nginx -w

# Check rollout history
kubectl rollout history deployment/nginx-deployment
```

## Verification Commands

After all updates, verify the final state:

```bash
# Comprehensive check
kubectl get deployment nginx-deployment -o wide
kubectl get service nginx-service -o wide
kubectl get pods -l app=nginx -o wide

# Detailed inspection
kubectl describe deployment nginx-deployment
kubectl describe service nginx-service

# Check endpoints
kubectl get endpoints nginx-service
```

## Expected Output

### Service
```
NAME            TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
nginx-service   NodePort   10.96.xxx.xxx   <none>        80:32165/TCP   xxm
```

### Deployment
```
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   5/5     5            5           xxm
```

### Pods
```
NAME                               READY   STATUS    RESTARTS   AGE
nginx-deployment-xxxxxxxxxx-xxxxx   1/1     Running   0          xxs
nginx-deployment-xxxxxxxxxx-xxxxx   1/1     Running   0          xxs
nginx-deployment-xxxxxxxxxx-xxxxx   1/1     Running   0          xxs
nginx-deployment-xxxxxxxxxx-xxxxx   1/1     Running   0          xxs
nginx-deployment-xxxxxxxxxx-xxxxx   1/1     Running   0          xxs
```

## Rollback Instructions

If you need to rollback the changes:

```bash
# Rollback to previous deployment version
kubectl rollout undo deployment/nginx-deployment

# Rollback to specific revision
kubectl rollout undo deployment/nginx-deployment --to-revision=<revision-number>

# Revert service NodePort (manual patch)
kubectl patch service nginx-service -p '{"spec":{"ports":[{"port":80,"nodePort":30008,"targetPort":80}]}}'

# Scale back down
kubectl scale deployment nginx-deployment --replicas=1
```

## Troubleshooting

### Pods Not Starting
```bash
# Check pod logs
kubectl logs <pod-name>

# Check pod events
kubectl describe pod <pod-name>

# Check deployment events
kubectl describe deployment nginx-deployment
```

### Service Not Accessible
```bash
# Verify service endpoints
kubectl get endpoints nginx-service

# Check node port availability
netstat -tuln | grep 32165

# Test service connectivity
curl <node-ip>:32165
```

### Image Pull Issues
```bash
# Check image pull status
kubectl get pods -l app=nginx
kubectl describe pod <pod-name> | grep -A 5 Events

# Verify image exists
docker pull nginx:latest
```

## Best Practices

1. **Backup First**: Export current configurations before changes
   ```bash
   kubectl get deployment nginx-deployment -o yaml > nginx-deployment-backup.yaml
   kubectl get service nginx-service -o yaml > nginx-service-backup.yaml
   ```

2. **Use --record Flag**: Track changes in rollout history
   ```bash
   kubectl set image deployment/nginx-deployment nginx=nginx:latest --record
   ```

3. **Monitor Gradually**: Watch each change complete before proceeding
   ```bash
   kubectl rollout status deployment/nginx-deployment
   ```

4. **Test Thoroughly**: Verify functionality after each update
   ```bash
   curl <node-ip>:32165
   ```

## Additional Resources

- [Kubernetes Deployments Documentation](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Kubernetes Services Documentation](https://kubernetes.io/docs/concepts/services-networking/service/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

## Support

For issues or questions, contact the Nautilus DevOps team.

---

**Last Updated:** October 2025  
**Version:** 1.0  
**Author:** Nautilus Application Development Team
