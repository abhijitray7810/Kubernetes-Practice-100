# Task: Deploy a Highly Available Nginx Website on Kubernetes

## Step 1: Create Deployment

Create a deployment named **nginx-deployment** using the **nginx:latest** image with 3 replicas.  
The container should be named **nginx-container**.

```bash
kubectl create deployment nginx-deployment \
  --image=nginx:latest \
  --replicas=3
````

Verify deployment and pods:

```bash
kubectl get deployments
kubectl get pods -l app=nginx
```

---

## Step 2: Expose Deployment as NodePort Service

Create a NodePort service named **nginx-service** and set the node port to **30011**.

```bash
kubectl expose deployment nginx-deployment \
  --type=NodePort \
  --name=nginx-service \
  --port=80 \
  --target-port=80 \
  --node-port=30011
```

Verify the service:

```bash
kubectl get svc nginx-service
```

Expected output:

```
NAME             TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
nginx-service    NodePort   10.96.xx.xx     <none>        80:30011/TCP   1m
```

---

## Step 3: Verify Access

Get Node IP:

```bash
kubectl get nodes -o wide
```

Access the Nginx default page from browser or curl:

```
http://<Node-IP>:30011
```

Example:

```
http://172.16.238.10:30011
```

---

✅ **Summary**

* **Deployment:** nginx-deployment
* **Replicas:** 3
* **Image:** nginx:latest
* **Container:** nginx-container
* **Service:** nginx-service
* **Type:** NodePort
* **NodePort:** 30011

```

---

Would you like me to include both **Deployment** and **Service YAML** in this same markdown file too (for backup/reference)?
```
