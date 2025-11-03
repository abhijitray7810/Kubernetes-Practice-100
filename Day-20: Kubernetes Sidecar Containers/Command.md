Here’s the full **`commands.md`** file with all necessary `kubectl` commands to complete the task step-by-step 👇

---

### ✅ **commands.md**

```bash
# Step 1: Create the Pod manifest file
cat <<EOF > webserver-pod.yaml
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
EOF


# Step 2: Apply the Pod definition to create the pod
kubectl apply -f webserver-pod.yaml


# Step 3: Verify that the Pod is running
kubectl get pods


# Step 4: Describe the Pod for details
kubectl describe pod webserver


# Step 5: Check logs from the sidecar container
kubectl logs -f webserver -c sidecar-container


# Step 6: (Optional) Check logs from the nginx container
kubectl logs -f webserver -c nginx-container
```

---

Would you like me to also include cleanup commands (to delete the pod and manifest after testing)?
