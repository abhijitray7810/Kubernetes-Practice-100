# Task: Create a ReplicationController for httpd

## Step 1: Create YAML file
```bash
vi httpd-replicationcontroller.yaml
````

Add the following content:

```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: httpd-replicationcontroller
  labels:
    app: httpd_app
    type: front-end
spec:
  replicas: 3
  selector:
    app: httpd_app
    type: front-end
  template:
    metadata:
      labels:
        app: httpd_app
        type: front-end
    spec:
      containers:
      - name: httpd-container
        image: httpd:latest
```

## Step 2: Apply the ReplicationController

```bash
kubectl apply -f httpd-replicationcontroller.yaml
```

## Step 3: Verify ReplicationController creation

```bash
kubectl get rc
```

## Step 4: Check Pods created by the ReplicationController

```bash
kubectl get pods -l app=httpd_app
```

## Step 5: Describe the ReplicationController (optional)

```bash
kubectl describe rc httpd-replicationcontroller
```

## Step 6: Confirm all pods are running

```bash
kubectl get pods
```

---

✅ **Expected Result:**

* A ReplicationController named `httpd-replicationcontroller` is created.
* It runs **3 replicas** of `httpd:latest` pods named `httpd-container`.
* All pods should be in the **Running** state.

```

---

Would you like me to generate a downloadable `.md` file for this?
```
