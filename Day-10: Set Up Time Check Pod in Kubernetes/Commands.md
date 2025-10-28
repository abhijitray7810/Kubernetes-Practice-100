# Command.md – Nautilus DevOps time-check pod

## 1. Create the namespace (one-time)
kubectl create namespace devops

## 2. Create the ConfigMap (one-time)
kubectl create configmap time-config \
  --from-literal=TIME_FREQ=5 \
  -n devops

## 3. Deploy the pod
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: time-check
  namespace: devops
spec:
  containers:
  - name: time-check
    image: busybox:latest
    command: ["/bin/sh","-c"]
    args:
      - |
        while true; do
          date >> /opt/sysops/time/time-check.log
          sleep $TIME_FREQ
        done
    env:
    - name: TIME_FREQ
      valueFrom:
        configMapKeyRef:
          name: time-config
          key: TIME_FREQ
    volumeMounts:
    - name: log-volume
      mountPath: /opt/sysops/time
  volumes:
  - name: log-volume
    emptyDir: {}
EOF

## 4. Verify
kubectl -n devops get pod time-check
kubectl -n devops exec time-check -- printenv TIME_FREQ
kubectl -n devops exec time-check -- cat /opt/sysops/time/time-check.log

## 5. Clean-up (when finished)
kubectl -n devops delete pod/time-check
kubectl -n devops delete cm/time-config
kubectl delete namespace devops
```
