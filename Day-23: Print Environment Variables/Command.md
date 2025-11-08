# Kubernetes Pod Deployment Commands

## Step 1: Create the Pod YAML File

Create a file named `print-envars-greeting-pod.yaml` with the pod configuration.

```bash
cat > print-envars-greeting-pod.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: print-envars-greeting
spec:
  containers:
  - name: print-env-container
    image: bash
    env:
    - name: GREETING
      value: "Welcome to"
    - name: COMPANY
      value: "xFusionCorp"
    - name: GROUP
      value: "Group"
    command: ["/bin/sh", "-c", "echo \"\$(GREETING) \$(COMPANY) \$(GROUP)\""]
  restartPolicy: Never
EOF
```

## Step 2: Apply the Pod Configuration

Deploy the pod to the Kubernetes cluster:

```bash
kubectl apply -f print-envars-greeting-pod.yaml
```

**Expected Output:**
```
pod/print-envars-greeting created
```

## Step 3: Verify Pod Creation

Check if the pod was created successfully:

```bash
kubectl get pods print-envars-greeting
```

**Expected Output:**
```
NAME                    READY   STATUS      RESTARTS   AGE
print-envars-greeting   0/1     Completed   0          10s
```

## Step 4: View Pod Logs

Check the output of the pod:

```bash
kubectl logs -f print-envars-greeting
```

**Expected Output:**
```
Welcome to xFusionCorp Group
```

## Additional Useful Commands

### View Pod Details
```bash
kubectl describe pod print-envars-greeting
```

### View Pod YAML Configuration
```bash
kubectl get pod print-envars-greeting -o yaml
```

### Delete the Pod (if needed)
```bash
kubectl delete pod print-envars-greeting
```

Or delete using the YAML file:
```bash
kubectl delete -f print-envars-greeting-pod.yaml
```

### Check Pod Status in Real-time
```bash
kubectl get pods print-envars-greeting -w
```

## Troubleshooting

### If Pod is in Error or CrashLoopBackOff State
```bash
kubectl logs print-envars-greeting
kubectl describe pod print-envars-greeting
```

### If Pod is Pending
```bash
kubectl describe pod print-envars-greeting
# Check the Events section for issues
```

## Verification Checklist

- ✅ Pod name is `print-envars-greeting`
- ✅ Container name is `print-env-container`
- ✅ Image is `bash`
- ✅ Environment variables are set correctly
- ✅ Command echoes the greeting message
- ✅ RestartPolicy is set to `Never`
- ✅ Logs show: `Welcome to xFusionCorp Group`
