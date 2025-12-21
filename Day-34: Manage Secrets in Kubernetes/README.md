# Kubernetes Secret Deployment – Nautilus DevOps

## Overview
This setup demonstrates how to securely store license/password information using **Kubernetes Secrets** and consume it inside a running pod.

A secret is created from an existing file on the jump host and mounted into a Debian container running in a Kubernetes cluster.

---

## Prerequisites
- Access to the **jump_host**
- `kubectl` configured to communicate with the Kubernetes cluster
- Secret file already present at:
```

/opt/blog.txt

````

---

## Step 1: Create Kubernetes Secret

A generic secret named `blog` is created using the file `blog.txt`.

```bash
kubectl create secret generic blog --from-file=blog.txt=/opt/blog.txt
````

Verify:

```bash
kubectl get secret blog
```

---

## Step 2: Pod Configuration

Pod details:

* **Pod Name:** `secret-devops`
* **Container Name:** `secret-container-devops`
* **Image:** `debian:latest`
* **Command:** `sleep infinity`
* **Secret Mount Path:** `/opt/games`

### Pod Manifest (`secret-pod.yaml`)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secret-devops
spec:
  containers:
    - name: secret-container-devops
      image: debian:latest
      command: ["sleep", "infinity"]
      volumeMounts:
        - name: blog-secret
          mountPath: /opt/games
  volumes:
    - name: blog-secret
      secret:
        secretName: blog
```

Apply the configuration:

```bash
kubectl apply -f secret-pod.yaml
```

---

## Step 3: Verify Pod Status

Ensure the pod is running:

```bash
kubectl get pod secret-devops
```

Expected status:

```
Running
```

---

## Step 4: Verify Secret Inside Container

Access the container:

```bash
kubectl exec -it secret-devops -c secret-container-devops -- bash
```

Check mounted secret:

```bash
ls /opt/games
cat /opt/games/blog.txt
```

The output should display the license/password stored in the secret.

---

## Notes

* Kubernetes Secrets are base64 encoded and should be handled securely.
* Validation may take a few moments after pod creation.
* Ensure the pod is in a **Running** state before verification.

---

## Conclusion

This setup successfully demonstrates secure storage and consumption of sensitive data using Kubernetes Secrets within a running pod.


