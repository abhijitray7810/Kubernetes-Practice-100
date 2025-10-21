### Kubernetes Job Creation Commands

#### 1. Apply Job using YAML

```bash
kubectl apply -f countdown-xfusion.yaml
```

#### 2. Optional: Directly create Job using `kubectl` command

```bash
kubectl create job countdown-xfusion --image=ubuntu:latest --restart=Never -- sleep 5
```

#### 3. Verify Job and Pod status

```bash
kubectl get jobs
kubectl get pods
```

#### 4. Check Pod logs

```bash
kubectl logs <pod-name>
```
