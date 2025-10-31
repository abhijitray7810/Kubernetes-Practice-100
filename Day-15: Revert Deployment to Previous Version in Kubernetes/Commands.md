# Rollback nginx-deployment to Previous Revision

## Task
The Nautilus DevOps team deployed a new release for an application, but a bug was reported.  
We need to roll back the **nginx-deployment** to its **previous revision**.

---

## Commands Used

### 1. Check rollout history
```bash
kubectl rollout history deployment nginx-deployment
````

### 2. Rollback to the previous revision

```bash
kubectl rollout undo deployment nginx-deployment
```

### 3. Verify rollback status

```bash
kubectl rollout status deployment nginx-deployment
```

### 4. Confirm image and revision after rollback

```bash
kubectl describe deployment nginx-deployment | grep -i image
kubectl rollout history deployment nginx-deployment
```

---

## Expected Output

* Deployment successfully rolled back.
* Pods running with the previous stable image version.

```
