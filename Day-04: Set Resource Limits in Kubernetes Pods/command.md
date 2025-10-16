# Commands to Create httpd-pod with Resource Limits

## Step 1: Create Pod Definition File
```bash
vi httpd-pod.yml
````

Add the following content:

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

## Step 2: Create the Pod

```bash
kubectl apply -f httpd-pod.yml
```

## Step 3: Verify Pod Status

```bash
kubectl get pods
```

## Step 4: Verify Resource Requests and Limits

```bash
kubectl describe pod httpd-pod | grep -A5 "Limits"
```

## Expected Output

```
Limits:
  cpu:     100m
  memory:  20Mi
Requests:
  cpu:     100m
  memory:  15Mi
```

---

This file documents all commands and configurations used to create the `httpd-pod` with specified resource constraints.

