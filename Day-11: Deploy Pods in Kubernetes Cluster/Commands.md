### **Steps and Commands**

#### **1. Create the YAML file**

```bash
vi pod-httpd.yml
```

#### **2. Add the following content**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-httpd
  labels:
    app: httpd_app
spec:
  containers:
    - name: httpd-container
      image: httpd:latest
```

#### **3. Apply the YAML file**

```bash
kubectl apply -f pod-httpd.yml
```

#### **4. Verify the pod status**

```bash
kubectl get pods
```

#### **5. Describe the pod (optional, for details)**

```bash
kubectl describe pod pod-httpd
```

---

### ✅ **Expected Output**

* Pod `pod-httpd` should be **Running**
* Container name: `httpd-container`
* Image: `httpd:latest`
* Label: `app=httpd_app`

---

Would you like me to include a short **LinkedIn-style project description** for this task too (like your other Kubernetes posts)?
