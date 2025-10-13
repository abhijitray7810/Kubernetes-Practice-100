# Kubernetes Namespace and Pod Deployment Commands

## Task: Create Namespace and Deploy Nginx Pod
**Objective**: Create a namespace named 'dev' and deploy a POD named 'dev-nginx-pod' using nginx:latest image within it.

## Commands

### 1. Create the 'dev' namespace
```bash
kubectl create namespace dev
```

### 2. Deploy the nginx pod in the dev namespace
```bash
kubectl run dev-nginx-pod --image=nginx:latest --namespace=dev --restart=Never
```

### 3. Verify the namespace creation
```bash
kubectl get namespaces
# or
kubectl get ns
```

### 4. Verify the pod is running
```bash
kubectl get pods -n dev
# or
kubectl get pods --namespace=dev
```

### 5. Get detailed information about the pod
```bash
kubectl describe pod dev-nginx-pod -n dev
```

### 6. Check pod logs (if needed)
```bash
kubectl logs dev-nginx-pod -n dev
```

### 7. Test nginx is working (optional)
```bash
kubectl exec -it dev-nginx-pod -n dev -- curl localhost
```

### 8. Get pod with additional details
```bash
kubectl get pods -n dev -o wide
```

### 9. Delete the pod (cleanup if needed)
```bash
kubectl delete pod dev-nginx-pod -n dev
```

### 10. Delete the namespace (cleanup if needed)
```bash
kubectl delete namespace dev
```

## YAML Alternative (Optional)

You can also create the resources using YAML files:

**namespace.yaml:**
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: dev
```

**pod.yaml:**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: dev-nginx-pod
  namespace: dev
spec:
  containers:
  - name: nginx
    image: nginx:latest
```

**Apply YAML files:**
```bash
kubectl apply -f namespace.yaml
kubectl apply -f pod.yaml
```

## Quick Reference

| Command | Description |
|---------|-------------|
| `kubectl create namespace dev` | Create dev namespace |
| `kubectl run dev-nginx-pod --image=nginx:latest --namespace=dev --restart=Never` | Create nginx pod |
| `kubectl get pods -n dev` | List pods in dev namespace |
| `kubectl describe pod dev-nginx-pod -n dev` | Get pod details |

## Notes
- The `--restart=Never` flag creates a standalone pod (not a deployment)
- The `-n dev` or `--namespace=dev` flag specifies the target namespace
- The pod uses `nginx:latest` image as specified in the requirements
```
