# 🚀 Kubernetes Rolling Update — nginx-deployment

### 🧾 Task Description
An application running on the Kubernetes cluster uses the **nginx web server**.  
The Nautilus DevOps team introduced recent changes that require updating the deployment to use the new image **nginx:1.18**.  

Deployment Name: **nginx-deployment**  
Existing Image: **nginx:1.16**  
Goal: Perform a **rolling update** to integrate **nginx:1.18** and verify all pods are running successfully.

---

## 🧠 Step-by-Step Commands

### 1️⃣ Check existing deployments
```bash
kubectl get deployments
````

### 2️⃣ Verify current image version

```bash
kubectl describe deployment nginx-deployment | grep -i image
```

### 3️⃣ Identify the container name inside the deployment

```bash
kubectl get deployment nginx-deployment -o yaml | grep "name:" | head
```

> Example Output:
>
> ```
> name: nginx-container
> ```

### 4️⃣ Perform rolling update to nginx:1.18

```bash
kubectl set image deployment/nginx-deployment nginx-container=nginx:1.18
```

### 5️⃣ Monitor the rollout process

```bash
kubectl rollout status deployment/nginx-deployment
```

### 6️⃣ Verify updated image

```bash
kubectl describe deployment nginx-deployment | grep -i image
```

### 7️⃣ Confirm all pods are in **Running** state

```bash
kubectl get pods
```

---

## ✅ Expected Results

* Deployment image updated successfully to **nginx:1.18**
* Rollout completed without errors
* All pods in **Running** state
* Zero downtime achieved during deployment

---

### 🧩 Verification Example

```bash
kubectl get pods
```

**Output:**

```
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-58cf54c7f6-kr6tc   1/1     Running   0          30s
nginx-deployment-58cf54c7f6-lhpph   1/1     Running   0          25s
nginx-deployment-58cf54c7f6-fpqmq   1/1     Running   0          3m50s
```

---

### 🏁 Summary

✅ Performed rolling update
✅ Verified successful rollout
✅ All pods running nginx:1.18
✅ Task completed successfully

---

**Author:** Abhijit Ray
**Category:** DevOps — Kubernetes Rolling Updates
**Date:** `October 30, 2025`

```
