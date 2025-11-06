### **commands.md**

```bash
# Step 1: Create a YAML file for the pod
vi webserver.yaml
```

**Add the following content:**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: webserver
spec:
  volumes:
    - name: shared-logs
      emptyDir: {}

  containers:
    - name: nginx-container
      image: nginx:latest
      volumeMounts:
        - name: shared-logs
          mountPath: /var/log/nginx

    - name: sidecar-container
      image: ubuntu:latest
      command: ["sh", "-c", "while true; do cat /var/log/nginx/access.log /var/log/nginx/error.log; sleep 30; done"]
      volumeMounts:
        - name: shared-logs
          mountPath: /var/log/nginx
```

---

```bash
# Step 2: Apply the YAML configuration
kubectl apply -f webserver.yaml
```

```bash
# Step 3: Verify the pod is created and running
kubectl get pods
```

```bash
# Step 4: Check logs from the sidecar container
kubectl logs webserver -c sidecar-container
```

```bash
# Step 5: Check logs from the nginx container (optional)
kubectl logs webserver -c nginx-container
```

---

✅ **Result:**
A pod named `webserver` will be created with two containers:

* `nginx-container` (serving web pages and generating logs)
* `sidecar-container` (continuously reading and outputting nginx logs)

Both share an `emptyDir` volume at `/var/log/nginx`.

---
