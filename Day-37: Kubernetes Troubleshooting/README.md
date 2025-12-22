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
