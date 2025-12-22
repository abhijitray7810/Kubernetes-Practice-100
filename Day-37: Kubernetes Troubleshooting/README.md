# MySQL Deployment on Kubernetes

This repository contains a Kubernetes YAML template to deploy a **MySQL database** using **Persistent Volumes**, **Persistent Volume Claims**, **Secrets**, and a **NodePort Service**.

The template was reviewed and fixed to resolve multiple YAML syntax and Kubernetes API issues while keeping **all original components intact**.

---

## 📁 Components Included

The deployment consists of the following Kubernetes resources:

- **PersistentVolume (PV)**  
  Provides 250Mi of storage using `hostPath`.

- **PersistentVolumeClaim (PVC)**  
  Requests storage from the PersistentVolume.

- **Service (NodePort)**  
  Exposes MySQL on port `30011`.

- **Deployment**  
  Runs MySQL `5.6` with environment variables sourced from Kubernetes Secrets.

---

## ⚙️ Prerequisites

- Kubernetes cluster up and running
- `kubectl` configured on the jump host
- The following Kubernetes secrets must exist:
  - `mysql-root-pass`
  - `mysql-db-url`
  - `mysql-user-pass`

Example secret creation:
```bash
kubectl create secret generic mysql-root-pass \
  --from-literal=password=rootpass
````

---

## 🚀 Deployment Steps

1. Navigate to the directory:

```bash
cd /home/thor
```

2. Apply the Kubernetes template:

```bash
kubectl apply -f mysql_deployment.yml
```

3. Verify resources:

```bash
kubectl get pv
kubectl get pvc
kubectl get pods
kubectl get svc
```

---

## 🔍 Access MySQL

Once the pod is running, MySQL will be accessible via:

* **NodePort:** `30011`
* **Port:** `3306`

Use the node’s IP address:

```bash
mysql -h <NODE_IP> -P 30011 -u <user> -p
```

---

## 🛠 Fixes Applied

The following issues were corrected:

* Incorrect `apiVersion` for Kubernetes resources
* Invalid resource kinds and casing
* YAML indentation and syntax errors
* Incorrect storage units (`MB` → `Mi`)
* Broken volume and PVC references
* Service selector mismatch
* Deployment selector misconfiguration
* Secret reference indentation errors

---

## 📌 Notes

* No components were removed during fixes.
* MySQL data persists even after pod restarts due to PV/PVC usage.
* Deployment uses `Recreate` strategy to avoid data corruption.

---

## ✅ Status

✔ Template validated
✔ Successfully applied using `kubectl apply`
✔ MySQL pod running and accessible

---

## 📄 Author

**Abhijit Ray**
DevOps Engineer | Kubernetes | Docker | CI/CD | Terraform

```

---

If you want, I can also:
- Add **architecture diagram**
- Convert this into a **GitHub-ready repo structure**
- Customize it for **LinkedIn post / DevOps lab submission**

Just tell me 👍
```
