
# Kubernetes Update Task

## Task Description
An application deployed on the Kubernetes cluster requires an update with new features developed by the Nautilus application development team.  
The existing setup includes:
- Deployment: **nginx-deployment**
- Service: **nginx-service**

### Required Changes
1. Modify the Service NodePort from **30008** to **32165**  
2. Change Deployment replicas count from **1** to **5**  
3. Update image from **nginx:1.19** to **nginx:latest**

---

## Step-by-Step Commands

### 1️⃣ Update Service NodePort
```bash
# Option 1: Edit manually
kubectl edit service nginx-service
````

Change:

```yaml
nodePort: 30008
```

To:

```yaml
nodePort: 32165
```

**OR use patch command directly:**

```bash
kubectl patch service nginx-service -p '{"spec": {"ports": [{"port": 80, "targetPort": 80, "nodePort": 32165}]}}'
```

---

### 2️⃣ Scale the Deployment to 5 Replicas

```bash
kubectl scale deployment nginx-deployment --replicas=5
```

Verify:

```bash
kubectl get deployment nginx-deployment
```

---

### 3️⃣ Update the Deployment Image

```bash
kubectl set image deployment/nginx-deployment nginx-container=nginx:latest
```

Check rollout:

```bash
kubectl rollout status deployment/nginx-deployment
```

---

### 4️⃣ Verify All Changes

```bash
kubectl get deployment nginx-deployment
kubectl describe deployment nginx-deployment | grep -i image
kubectl get service nginx-service
```

---

## ✅ Expected Outcome

* **Service NodePort:** 32165
* **Deployment Replicas:** 5
* **Image:** nginx:latest
* All pods running successfully.

---
