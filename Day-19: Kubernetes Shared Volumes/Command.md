# Commands to Create Shared Volume Pod on Kubernetes

## Step 1: Create Pod manifest
```bash
cat <<EOF > volume-share-datacenter.yaml
apiVersion: v1
kind: Pod
metadata:
  name: volume-share-datacenter
spec:
  containers:
    - name: volume-container-datacenter-1
      image: debian:latest
      command: ["sleep", "3600"]
      volumeMounts:
        - name: volume-share
          mountPath: /tmp/ecommerce

    - name: volume-container-datacenter-2
      image: debian:latest
      command: ["sleep", "3600"]
      volumeMounts:
        - name: volume-share
          mountPath: /tmp/demo

  volumes:
    - name: volume-share
      emptyDir: {}
EOF
````

---

## Step 2: Create the Pod

```bash
kubectl apply -f volume-share-datacenter.yaml
```

---

## Step 3: Verify Pod status

```bash
kubectl get pods
```

Expected:

```
NAME                       READY   STATUS    RESTARTS   AGE
volume-share-datacenter    2/2     Running   0          10s
```

---

## Step 4: Exec into first container and create test file

```bash
kubectl exec -it volume-share-datacenter -c volume-container-datacenter-1 -- bash
echo "Shared data test" > /tmp/ecommerce/ecommerce.txt
exit
```

---

## Step 5: Verify shared file from second container

```bash
kubectl exec -it volume-share-datacenter -c volume-container-datacenter-2 -- bash
cat /tmp/demo/ecommerce.txt
exit
```

Expected output:

```
Shared data test
```

---

✅ **Result:**
The file `ecommerce.txt` created in container `volume-container-datacenter-1` under `/tmp/ecommerce` is visible in container `volume-container-datacenter-2` under `/tmp/demo`, confirming that the shared volume (`emptyDir`) is working correctly.

```

---

Would you like me to include cleanup commands (to delete the pod and YAML file after verification) at the end?
```
