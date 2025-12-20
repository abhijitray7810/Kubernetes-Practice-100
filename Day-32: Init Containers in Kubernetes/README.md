# Kubernetes Init Container Deployment

## Overview

This project demonstrates the use of Kubernetes init containers to perform prerequisite tasks before the main application container starts. The init container prepares configuration data that the main container consumes.

## Scenario

The DevOps team needs to deploy applications that require configuration changes before the main application starts. Since these changes cannot be made inside the container images, init containers are used to handle these prerequisite tasks during deployment.

## Architecture

The deployment consists of:

- **Init Container**: Prepares a welcome message file
- **Main Container**: Continuously reads and displays the message
- **Shared Volume**: EmptyDir volume for data sharing between containers

## Deployment Specifications

### Deployment Details
- **Name**: `ic-deploy-nautilus`
- **Replicas**: 1
- **Labels**: `app: ic-nautilus`

### Init Container (`ic-msg-nautilus`)
- **Image**: `debian:latest`
- **Purpose**: Write initialization message to shared volume
- **Command**: Creates file `/ic/news` with welcome message
- **Volume Mount**: `/ic` (ic-volume-nautilus)

### Main Container (`ic-main-nautilus`)
- **Image**: `debian:latest`
- **Purpose**: Read and display the message every 5 seconds
- **Command**: Continuous loop reading from `/ic/news`
- **Volume Mount**: `/ic` (ic-volume-nautilus)

### Volume (`ic-volume-nautilus`)
- **Type**: emptyDir
- **Purpose**: Temporary storage shared between init and main containers

## Prerequisites

- Kubernetes cluster access
- `kubectl` configured to work with the cluster
- Appropriate permissions to create deployments

## Deployment Steps

### 1. Apply the Deployment

```bash
kubectl apply -f ic-deploy-nautilus.yaml
```

### 2. Verify Deployment Status

```bash
# Check deployment
kubectl get deployments ic-deploy-nautilus

# Check pods
kubectl get pods -l app=ic-nautilus

# Detailed pod information
kubectl describe pod -l app=ic-nautilus
```

### 3. View Logs

```bash
# Follow logs from the main container
kubectl logs -l app=ic-nautilus -f

# View logs from a specific pod
kubectl logs <pod-name> -c ic-main-nautilus

# View init container logs
kubectl logs <pod-name> -c ic-msg-nautilus
```

## Expected Output

Once deployed, the main container logs should display:

```
Init Done - Welcome to xFusionCorp Industries
Init Done - Welcome to xFusionCorp Industries
Init Done - Welcome to xFusionCorp Industries
...
```

The message repeats every 5 seconds.

## Container Lifecycle

1. **Pod Creation**: Kubernetes creates the pod
2. **Init Container Execution**: `ic-msg-nautilus` runs and creates the message file
3. **Init Container Completion**: Init container exits successfully
4. **Main Container Start**: `ic-main-nautilus` starts after init container completes
5. **Continuous Operation**: Main container reads and displays the message

## Troubleshooting

### Pod Not Starting

```bash
# Check pod status
kubectl get pods -l app=ic-nautilus

# View pod events
kubectl describe pod -l app=ic-nautilus
```

### Init Container Fails

```bash
# Check init container logs
kubectl logs <pod-name> -c ic-msg-nautilus
```

### Main Container Issues

```bash
# Check main container logs
kubectl logs <pod-name> -c ic-main-nautilus

# Execute commands inside the container
kubectl exec -it <pod-name> -- /bin/bash
```

## Cleanup

To remove the deployment:

```bash
# Delete the deployment
kubectl delete deployment ic-deploy-nautilus

# Verify deletion
kubectl get deployments
kubectl get pods -l app=ic-nautilus
```

## Use Cases for Init Containers

This pattern is useful for:

- Pre-populating configuration files
- Waiting for dependencies to be ready
- Performing database migrations
- Setting up permissions and ownership
- Downloading required assets or data
- Network or service discovery setup

## Technical Notes

- **EmptyDir Volume**: Provides temporary storage that exists for the pod's lifetime. Data is lost when the pod is deleted.
- **Init Container Guarantee**: Init containers always run to completion before main containers start
- **Sequential Execution**: Multiple init containers run sequentially in the order defined
- **Resource Sharing**: Init and main containers can share volumes for data transfer

## Additional Commands

```bash
# Watch pod status in real-time
kubectl get pods -l app=ic-nautilus -w

# Get detailed YAML output
kubectl get deployment ic-deploy-nautilus -o yaml

# Edit deployment on the fly
kubectl edit deployment ic-deploy-nautilus

# Scale the deployment
kubectl scale deployment ic-deploy-nautilus --replicas=3
```

## References

- [Kubernetes Init Containers Documentation](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)
- [Kubernetes Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Kubernetes Volumes](https://kubernetes.io/docs/concepts/storage/volumes/)

## Author

xFusionCorp Industries DevOps Team

## License

Internal Use Only
