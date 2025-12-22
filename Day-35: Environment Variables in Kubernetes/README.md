# Kubernetes Pod with Environment Variables

This repository contains a Kubernetes Pod configuration that demonstrates how to use the Downward API to expose Pod and Node information as environment variables within containers.

## Overview

The configuration creates a Pod named `envars` that runs an `httpd` container. The container uses environment variables populated by Kubernetes metadata through the Downward API's `fieldRef` mechanism.

## Prerequisites

- Access to a Kubernetes cluster
- `kubectl` configured to communicate with your cluster
- Appropriate permissions to create Pods

## Pod Specifications

### Basic Configuration
- **Pod Name**: `envars`
- **Container Name**: `fieldref-container`
- **Image**: `httpd:latest`
- **Restart Policy**: `Never`

### Environment Variables

The Pod defines four environment variables using the Kubernetes Downward API:

| Variable Name | Source Field | Description |
|---------------|--------------|-------------|
| `NODE_NAME` | `spec.nodeName` | Name of the node where the pod is running |
| `POD_NAME` | `metadata.name` | Name of the pod |
| `POD_IP` | `status.podIP` | IP address assigned to the pod |
| `POD_SERVICE_ACCOUNT` | `spec.serviceAccountName` | Service account used by the pod |

### Container Behavior

The container runs a continuous loop that:
1. Prints a newline character
2. Displays `NODE_NAME` and `POD_NAME` values
3. Displays `POD_IP` and `POD_SERVICE_ACCOUNT` values
4. Sleeps for 10 seconds
5. Repeats indefinitely

## Deployment Instructions

### Method 1: Using YAML File

1. **Create the YAML file**:
```bash
cat > envars-pod.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: envars
spec:
  restartPolicy: Never
  containers:
  - name: fieldref-container
    image: httpd:latest
    command: ['sh', '-c']
    args:
    - 'while true; do echo -en ''\n''; printenv NODE_NAME POD_NAME; printenv POD_IP POD_SERVICE_ACCOUNT; sleep 10; done;'
    env:
    - name: NODE_NAME
      valueFrom:
        fieldRef:
          fieldPath: spec.nodeName
    - name: POD_NAME
      valueFrom:
        fieldRef:
          fieldPath: metadata.name
    - name: POD_IP
      valueFrom:
        fieldRef:
          fieldPath: status.podIP
    - name: POD_SERVICE_ACCOUNT
      valueFrom:
        fieldRef:
          fieldPath: spec.serviceAccountName
EOF
```

2. **Apply the configuration**:
```bash
kubectl apply -f envars-pod.yaml
```

### Method 2: Direct Apply

```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: envars
spec:
  restartPolicy: Never
  containers:
  - name: fieldref-container
    image: httpd:latest
    command: ['sh', '-c']
    args:
    - 'while true; do echo -en ''\n''; printenv NODE_NAME POD_NAME; printenv POD_IP POD_SERVICE_ACCOUNT; sleep 10; done;'
    env:
    - name: NODE_NAME
      valueFrom:
        fieldRef:
          fieldPath: spec.nodeName
    - name: POD_NAME
      valueFrom:
        fieldRef:
          fieldPath: metadata.name
    - name: POD_IP
      valueFrom:
        fieldRef:
          fieldPath: status.podIP
    - name: POD_SERVICE_ACCOUNT
      valueFrom:
        fieldRef:
          fieldPath: spec.serviceAccountName
EOF
```

## Verification Steps

### 1. Check Pod Status
```bash
kubectl get pod envars
```

Expected output:
```
NAME     READY   STATUS    RESTARTS   AGE
envars   1/1     Running   0          10s
```

### 2. View Pod Logs
```bash
kubectl logs envars
```

Expected output (example):
```
envars node01
10.244.1.5 default
envars node01
10.244.1.5 default
...
```

### 3. View Pod Details
```bash
kubectl describe pod envars
```

### 4. Execute Commands Inside the Pod

**View all environment variables**:
```bash
kubectl exec envars -- printenv
```

**View specific environment variables**:
```bash
kubectl exec envars -- printenv NODE_NAME POD_NAME POD_IP POD_SERVICE_ACCOUNT
```

**Interactive shell access**:
```bash
kubectl exec -it envars -- sh
```

Then inside the pod:
```bash
printenv | grep -E 'NODE_NAME|POD_NAME|POD_IP|POD_SERVICE_ACCOUNT'
```

## Troubleshooting

### Pod Not Starting

**Check pod events**:
```bash
kubectl describe pod envars
```

**Check pod logs**:
```bash
kubectl logs envars
```

### YAML Parsing Errors

Ensure proper indentation (use spaces, not tabs) and correct quote escaping in the args section.

### Image Pull Issues

If the `httpd:latest` image cannot be pulled:
```bash
kubectl describe pod envars | grep -A 5 Events
```

## Cleanup

To delete the pod:
```bash
kubectl delete pod envars
```

Or using the YAML file:
```bash
kubectl delete -f envars-pod.yaml
```

## Understanding the Downward API

The Downward API allows containers to consume information about themselves or the cluster without using the Kubernetes API directly. This is useful for:

- **Configuration**: Passing pod-specific information to applications
- **Logging**: Including pod/node information in application logs
- **Monitoring**: Exposing metadata for monitoring systems
- **Service Discovery**: Using pod IP and names for internal communication

### Available Field References

Common fields that can be exposed via `fieldRef`:

- `metadata.name` - Pod name
- `metadata.namespace` - Pod namespace
- `metadata.uid` - Pod UID
- `metadata.labels['<KEY>']` - Specific label value
- `metadata.annotations['<KEY>']` - Specific annotation value
- `spec.nodeName` - Node name
- `spec.serviceAccountName` - Service account name
- `status.podIP` - Pod IP address
- `status.hostIP` - Node IP address

## References

- [Kubernetes Downward API Documentation](https://kubernetes.io/docs/concepts/workloads/pods/downward-api/)
- [Kubernetes Environment Variables](https://kubernetes.io/docs/tasks/inject-data-application/environment-variable-expose-pod-information/)

## License

This configuration is provided as-is for educational and demonstration purposes.
