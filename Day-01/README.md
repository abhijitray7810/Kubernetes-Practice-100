# Kubernetes Pod Creation Task – pod-httpd

## Objective
Create a pod named **pod-httpd** using the **httpd:latest** image.  
Label the pod with **app=httpd_app** and name the container **httpd-container**.

---

## Files Included
- **questions.md** → Problem statement  
- **steps.md** → Step-by-step solution  
- **commands.md** → All required commands  
- **pod-httpd.yaml** → Kubernetes manifest file  

---

## Verification
After applying the YAML file, use the following commands to confirm:

```bash
kubectl get pods
kubectl get pod pod-httpd --show-labels

