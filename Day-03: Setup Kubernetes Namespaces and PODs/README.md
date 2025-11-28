 # Kubernetes Namespace and Pod Deployment

## 📘 Task Overview
The Nautilus DevOps team planned to deploy microservices on a Kubernetes cluster.  
As part of the setup, a dedicated namespace and pod need to be created using the **nginx** image.

---

 ## ⚙️ Task Details

- **Namespace Name:** `dev`  
- **Pod Name:** `dev-nginx-pod`  
- **Container Image:** `nginx:latest`

---

## 🧩 Steps to Complete

### 1️⃣ Create a Namespace
```bash
kubectl create namespace dev
````

### 2️⃣ Deploy a Pod in the Namespace

```bash
kubectl run dev-nginx-pod --image=nginx:latest -n dev
```

### 3️⃣ Verify the Pod Creation

```bash
kubectl get pods -n dev
```

Expected output:

```
NAME             READY   STATUS    RESTARTS   AGE
dev-nginx-pod    1/1     Running   0          10s
```

### 4️⃣ (Optional) Describe the Pod

```bash
kubectl describe pod dev-nginx-pod -n dev
```

---

## ✅ Summary

* A new namespace `dev` has been created.
* A pod named `dev-nginx-pod` has been deployed inside it using the `nginx:latest` image.
* The pod runs successfully within the `dev` namespace.

---

## 🧠 Notes

* Ensure that `kubectl` is properly configured to communicate with your Kubernetes cluster.
* Use `kubectl config get-contexts` to verify your active context if needed.

---

### 🏁 Example Verification

To verify all namespaces:

```bash
kubectl get namespaces
```

To verify all resources in the `dev` namespace:

```bash
kubectl get all -n dev
```

---

**Author:** Nautilus DevOps Team
**Date:** October 2025

 
