# Redis Deployment on Kubernetes

## Project Overview
This project demonstrates deploying **Redis** on a Kubernetes cluster with a ConfigMap and persistent storage. The deployment is intended for testing and prototyping Redis caching before moving to production.

The setup includes:
- A Redis deployment (`redis-deployment`) with 1 replica
- ConfigMap for Redis configuration
- Volumes for persistent and configuration storage
- CPU resource request

---

## Prerequisites
- Kubernetes cluster access
- `kubectl` configured on your jump host
- Redis Docker image: `redis:alpine`

---

## Deployment Instructions

### Step 1: Create ConfigMap
Create a ConfigMap to configure Redis memory:

```bash
kubectl create configmap my-redis-config --from-literal=redis-config="maxmemory 2mb"
````

---

### Step 2: Create Deployment YAML

Create a file `redis-deployment.yaml` with the following content:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis-app
  template:
    metadata:
      labels:
        app: redis-app
    spec:
      containers:
      - name: redis-container
        image: redis:alpine
        ports:
        - containerPort: 6379
        resources:
          requests:
            cpu: "1"
        volumeMounts:
        - name: data
          mountPath: /redis-master-data
        - name: redis-config
          mountPath: /redis-master
          readOnly: true
      volumes:
      - name: data
        emptyDir: {}
      - name: redis-config
        configMap:
          name: my-redis-config
          items:
            - key: redis-config
              path: redis.conf
```

---

### Step 3: Apply Deployment

```bash
kubectl apply -f redis-deployment.yaml
```

---

### Step 4: Verify Deployment

Check pod status:

```bash
kubectl get pods
```

Expected output:

```
redis-deployment-xxxxx   1/1   Running
```

Describe the deployment:

```bash
kubectl describe deployment redis-deployment
```

---

### Step 5: Verify ConfigMap Mount

Check the configuration inside the pod:

```bash
kubectl exec -it <pod-name> -- cat /redis-master/redis.conf
```

Output should show:

```
maxmemory 2mb
```

---

### Step 6: Test Redis

Inside the pod:

```bash
kubectl exec -it <pod-name> -- redis-cli ping
```

Expected response:

```
PONG
```

---

## Resources Used

* Deployment: `redis-deployment`
* Container: `redis-container`
* Image: `redis:alpine`
* ConfigMap: `my-redis-config`
* EmptyDir volume: `/redis-master-data`
* ConfigMap volume: `/redis-master`
* CPU request: 1
* Port exposed: 6379

---

## Author

**Your Name**
DevOps / Kubernetes Enthusiast

```

---

This README is **complete, clear, and aligned with your lab task**.  

If you want, I can also create a **condensed version** that fits in **one page** for KodeKloud labs — this is often preferred for fast submission.  

Do you want me to do that?
```
