
# MySQL Deployment on Kubernetes

## Project Overview
This project demonstrates deploying a **MySQL database** on a Kubernetes cluster with persistent storage and secure credentials using Kubernetes Secrets. The deployment includes:

- PersistentVolume (PV) and PersistentVolumeClaim (PVC) for data persistence
- Deployment with 1 replica of MySQL container
- Secrets for root password, user credentials, and database name
- NodePort Service for external access

This setup is suitable for testing and development purposes.

---

## Prerequisites
- Kubernetes cluster access
- `kubectl` configured on jump host
- Docker image: `mysql:8.0` (or any MySQL version)
- NodePort availability (30007)

---

## Deployment Instructions

### Step 1: Create PersistentVolume
Create a file `mysql-pv.yaml`:

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mysql-pv
spec:
  capacity:
    storage: 250Mi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: manual
  hostPath:
    path: "/mnt/data/mysql"
````

Apply PV:

```bash
kubectl apply -f mysql-pv.yaml
```

---

### Step 2: Create PersistentVolumeClaim

Create `mysql-pvc.yaml`:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pv-claim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 250Mi
  storageClassName: manual
```

Apply PVC:

```bash
kubectl apply -f mysql-pvc.yaml
```

---

### Step 3: Create Secrets

Create `mysql-secrets.yaml`:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysql-root-pass
type: Opaque
stringData:
  password: YUIidhb667
---
apiVersion: v1
kind: Secret
metadata:
  name: mysql-user-pass
type: Opaque
stringData:
  username: kodekloud_tim
  password: GyQkFRVNr3
---
apiVersion: v1
kind: Secret
metadata:
  name: mysql-db-url
type: Opaque
stringData:
  database: kodekloud_db9
```

Apply Secrets:

```bash
kubectl apply -f mysql-secrets.yaml
```

---

### Step 4: Create MySQL Deployment

Create `mysql-deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql-app
  template:
    metadata:
      labels:
        app: mysql-app
    spec:
      containers:
      - name: mysql-container
        image: mysql:8.0
        ports:
        - containerPort: 3306
        env:
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-root-pass
              key: password
        - name: MYSQL_DATABASE
          valueFrom:
            secretKeyRef:
              name: mysql-db-url
              key: database
        - name: MYSQL_USER
          valueFrom:
            secretKeyRef:
              name: mysql-user-pass
              key: username
        - name: MYSQL_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-user-pass
              key: password
        volumeMounts:
        - name: mysql-storage
          mountPath: /var/lib/mysql
      volumes:
      - name: mysql-storage
        persistentVolumeClaim:
          claimName: mysql-pv-claim
```

Apply deployment:

```bash
kubectl apply -f mysql-deployment.yaml
```

---

### Step 5: Create NodePort Service

Create `mysql-service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql
spec:
  type: NodePort
  selector:
    app: mysql-app
  ports:
  - port: 3306
    targetPort: 3306
    nodePort: 30007
```

Apply service:

```bash
kubectl apply -f mysql-service.yaml
```

---

### Step 6: Verify Deployment

Check pod status:

```bash
kubectl get pods
```

Check PV and PVC:

```bash
kubectl get pv
kubectl get pvc
```

Check service:

```bash
kubectl get svc
```

Expected:

* Pod is **Running**
* PV and PVC **Bound**
* Service NodePort = **30007**
* Environment variables correctly injected from Secrets

---

### Step 7: Test MySQL Connection (Optional)

```bash
kubectl exec -it <pod-name> -- mysql -u kodekloud_tim -p
```

Enter the password from `mysql-user-pass` secret: `GyQkFRVNr3`

---

## Resources Summary

| Resource Type         | Name                                           |
| --------------------- | ---------------------------------------------- |
| PersistentVolume      | mysql-pv                                       |
| PersistentVolumeClaim | mysql-pv-claim                                 |
| Deployment            | mysql-deployment                               |
| Container             | mysql-container                                |
| Service               | mysql (NodePort 30007)                         |
| Secrets               | mysql-root-pass, mysql-user-pass, mysql-db-url |

---

## Author

**Your Name**
DevOps / Kubernetes Enthusiast

```

---

