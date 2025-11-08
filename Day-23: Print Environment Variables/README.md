# Nautilus DevOps - Print Environment Variables Greeting Pod

## Overview

This project contains the Kubernetes configuration for a simple pod that demonstrates environment variable usage by printing a greeting message. This is a prerequisite setup for the Nautilus DevOps team's application that will send greetings to different users.

## Purpose

The pod is designed to:
- Test environment variable configuration in Kubernetes
- Validate pod creation and execution
- Verify logging capabilities
- Demonstrate single-run pod behavior with `restartPolicy: Never`

## Project Structure

```
.
├── README.md                           # This file
├── commands.md                         # Detailed command reference
└── print-envars-greeting-pod.yaml     # Kubernetes pod manifest
```

## Prerequisites

- Access to Kubernetes cluster
- `kubectl` utility configured on jump_host
- Appropriate permissions to create pods in the cluster

## Pod Specifications

| Property | Value |
|----------|-------|
| Pod Name | `print-envars-greeting` |
| Container Name | `print-env-container` |
| Image | `bash` |
| Restart Policy | `Never` |

### Environment Variables

| Variable | Value |
|----------|-------|
| GREETING | `Welcome to` |
| COMPANY | `xFusionCorp` |
| GROUP | `Group` |

### Command

The pod executes the following command:
```bash
/bin/sh -c 'echo "$(GREETING) $(COMPANY) $(GROUP)"'
```

## Quick Start

### 1. Deploy the Pod

```bash
kubectl apply -f print-envars-greeting-pod.yaml
```

### 2. Verify Deployment

```bash
kubectl get pods print-envars-greeting
```

### 3. View Output

```bash
kubectl logs -f print-envars-greeting
```

**Expected Output:**
```
Welcome to xFusionCorp Group
```

## Detailed Instructions

For detailed step-by-step instructions and additional commands, please refer to [commands.md](commands.md).

## How It Works

1. **Pod Creation**: Kubernetes creates a pod with a single container using the bash image
2. **Environment Setup**: Three environment variables are injected into the container
3. **Command Execution**: The container executes a shell command that echoes the environment variables
4. **Completion**: The pod completes successfully and stops (due to `restartPolicy: Never`)
5. **Log Retention**: The logs remain available for viewing even after the pod completes

## Pod Lifecycle

```
Pending → Running → Completed
```

- **Pending**: Pod is being scheduled and image is being pulled
- **Running**: Command is executing
- **Completed**: Command finished successfully (exit code 0)

## Troubleshooting

### Pod Stuck in Pending
- Check cluster resources: `kubectl describe pod print-envars-greeting`
- Verify image availability

### Pod in Error State
- Check logs: `kubectl logs print-envars-greeting`
- Review pod events: `kubectl describe pod print-envars-greeting`

### Cannot View Logs
- Ensure pod has completed or is running
- Check pod status: `kubectl get pods print-envars-greeting`

## Cleanup

To remove the pod from the cluster:

```bash
kubectl delete pod print-envars-greeting
```

Or using the manifest file:

```bash
kubectl delete -f print-envars-greeting-pod.yaml
```

## Testing Checklist

- [ ] Pod created successfully
- [ ] Pod status shows `Completed`
- [ ] Logs display: `Welcome to xFusionCorp Group`
- [ ] No restarts occurred (RESTARTS = 0)
- [ ] Container name is `print-env-container`
- [ ] All three environment variables are set correctly

## Notes

- The pod uses `restartPolicy: Never` to prevent crash loop back
- This is a one-time execution pod, not a long-running service
- Logs persist after pod completion for review
- The bash image is lightweight and suitable for simple shell commands

## Support

For issues or questions:
- Review the [commands.md](commands.md) file for detailed command reference
- Check Kubernetes cluster logs
- Verify kubectl configuration

## Version Information

- Kubernetes API Version: v1
- Resource Type: Pod
- Image: bash (latest)

---

**Nautilus DevOps Team** | xFusionCorp Industries
