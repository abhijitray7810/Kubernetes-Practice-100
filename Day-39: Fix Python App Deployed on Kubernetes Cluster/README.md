# Python Flask Demo App on Kubernetes

## Project Overview
This project demonstrates deploying a simple Python Flask application on a Kubernetes cluster. The application is exposed externally using a NodePort service.

The setup includes:
- Deployment of a Flask app container
- Kubernetes Service with NodePort for external access
- Correct container and service configuration for smooth access

---

## Prerequisites
- Kubernetes cluster access
- `kubectl` configured on your local machine or jump host
- Docker image: `poroko/flask-demo-app`
- NodePort available (e.g., `32345`)

---

## Deployment Instructions

### Step 1: Verify Kubernetes Cluster
```bash
kubectl get nodes
kubectl cluster-info
````

### Step 2: Check Existing Deployment

```bash
kubectl get deployments
kubectl describe deployment python-deployment-nautilus
```

### Step 3: Update Deployment Image (if needed)

```bash
kubectl edit deployment python-deployment-nautilus
```

Ensure the image is:

```yaml
image: poroko/flask-demo-app
```

Restart deployment:

```bash
kubectl rollout restart deployment python-deployment-nautilus
```

---

### Step 4: Verify Pod Status

```bash
kubectl get pods
```

Expected: `1/1 Running`

---

### Step 5: Verify Service

```bash
kubectl get svc python-service-nautilus
kubectl describe svc python-service-nautilus
```

Ensure:

* NodePort: `32345`
* targetPort: `5000`
* Service name: `python-service-nautilus`

---

### Step 6: Access Application

1. Get Node IP:

```bash
kubectl get nodes -o wide
```

2. Open in browser:

```
http://<NODE-IP>:32345
```

You should see the Flask demo app page.

---

## Troubleshooting

* **Pod stuck in `ImagePullBackOff`**

  * Check image name in deployment
  * Update deployment with correct image

* **502 Bad Gateway**

  * Check `targetPort` in Service; should be `5000`
  * NodePort should match the required external port

* **NodePort not accessible**

  * Ensure NodePort is not already used by another Service
  * Use `kubectl get svc --all-namespaces` to check conflicts

---

## Key Commands

```bash
kubectl get pods
kubectl get svc
kubectl describe deployment <deployment-name>
kubectl describe svc <service-name>
kubectl edit deployment <deployment-name>
kubectl edit svc <service-name>
kubectl rollout restart deployment <deployment-name>
```

---

## Author

**Your Name**
DevOps / Kubernetes Enthusiast

---

```

This README is **complete for a DevOps task**: it documents the deployment, how to verify it, troubleshooting steps, and commands.  

I can also create a **short, ultra-succinct README** optimized for **KodeKloud labs submission** if you want — it would fit in one page and directly show the evaluator what’s done.  

Do you want me to create that version too?
```
