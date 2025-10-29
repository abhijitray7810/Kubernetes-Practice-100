# 🧩 Kubernetes Pod with Resource Limits

This project demonstrates how to create a **Kubernetes Pod** with defined **CPU and memory requests and limits** to ensure stable performance and prevent resource contention in cluster environments.

---

## 📘 **Project Overview**

The Nautilus DevOps team identified performance issues in some Kubernetes-hosted applications due to unrestricted resource usage.
To address this, a pod named **`httpd-pod`** is created with a container **`httpd-container`** using the **`httpd:latest`** image.
Resource requests and limits are applied to optimize performance and ensure fair resource distribution.

---

## ⚙️ **Configuration Details**

| Resource Type | Memory | CPU  |
| ------------- | ------ | ---- |
| **Requests**  | 15Mi   | 100m |
| **Limits**    | 20Mi   | 100m |

---

## 🧱 **YAML Definition**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: httpd-pod
spec:
  containers:
    - name: httpd-container
      image: httpd:latest
      resources:
        requests:
          memory: "15Mi"
          cpu: "100m"
        limits:
          memory: "20Mi"
          cpu: "100m"
```

---

## 🧭 **How to Deploy**

1. Create the pod definition file:

   ```bash
   vi httpd-pod.yml
   ```
2. Apply the configuration:

   ```bash
   kubectl apply -f httpd-pod.yml
   ```
3. Verify pod creation:

   ```bash
   kubectl get pods
   ```
4. Check resource details:

   ```bash
   kubectl describe pod httpd-pod
   ```

---

## ✅ **Expected Output**

```
Name:         httpd-pod
Containers:
  httpd-container:
    Image:          httpd:latest
    Limits:
      cpu:     100m
      memory:  20Mi
    Requests:
      cpu:     100m
      memory:  15Mi
```

---

## 🧑‍💻 **Author**

**Nautilus DevOps Team**
*Kubernetes Resource Management Task*
