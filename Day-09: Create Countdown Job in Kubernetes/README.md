# Kubernetes Job - countdown-xfusion

## Overview

This repository contains a Kubernetes Job template created for the Nautilus DevOps team. The job is designed for testing purposes and runs a dummy command to validate the job configuration and execution workflow.

## Job Specifications

- **Job Name**: `countdown-xfusion`
- **Template Name**: `countdown-xfusion`
- **Container Name**: `container-countdown-xfusion`
- **Image**: `ubuntu:latest`
- **Restart Policy**: `Never`
- **Command**: `sleep 5`

## Prerequisites

- Access to `jump_host` with `kubectl` configured
- Kubernetes cluster access
- Appropriate RBAC permissions to create jobs

## Deployment Instructions

### 1. Apply the Job

```bash
kubectl apply -f countdown-xfusion-job.yaml
```

### 2. Verify Job Creation

```bash
kubectl get jobs
```

Expected output:
```
NAME                 COMPLETIONS   DURATION   AGE
countdown-xfusion    0/1           5s         5s
```

### 3. Check Job Status

```bash
kubectl describe job countdown-xfusion
```

### 4. View Pod Status

```bash
kubectl get pods --selector=job-name=countdown-xfusion
```

### 5. Check Logs

```bash
kubectl logs job/countdown-xfusion
```

Or get the pod name and check logs:
```bash
POD_NAME=$(kubectl get pods --selector=job-name=countdown-xfusion -o jsonpath='{.items[0].metadata.name}')
kubectl logs $POD_NAME
```

## Job Behavior

- The job creates a single pod that executes the `sleep 5` command
- After 5 seconds, the command completes successfully
- The pod status changes to `Completed`
- With `restartPolicy: Never`, the pod will not restart after completion
- The job is marked as complete with 1/1 completions

## Cleanup

To remove the job and associated resources:

```bash
kubectl delete job countdown-xfusion
```

This will also delete the completed pod(s) associated with this job.

## Troubleshooting

### Job Not Starting

Check if there are resource constraints:
```bash
kubectl describe job countdown-xfusion
kubectl get events --sort-by='.lastTimestamp'
```

### Pod Failed

View pod details and logs:
```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

### Image Pull Issues

Verify image availability:
```bash
kubectl describe pod <pod-name> | grep -A 5 Events
```

## File Structure

```
.
├── README.md
└── countdown-xfusion-job.yaml
```

## Notes

- This is a template job using a dummy command for testing purposes
- In production, replace the `sleep 5` command with actual scripts/commands
- The `restartPolicy: Never` ensures the job doesn't retry on completion
- Jobs are designed for batch processing and one-time task execution

## Next Steps

Once this template is validated, the DevOps team can:
1. Replace the dummy command with actual workload scripts
2. Add environment variables as needed
3. Configure resource limits and requests
4. Implement job completion tracking and notifications
5. Set up job retry logic with `backoffLimit` if needed

## Support

For issues or questions, contact the Nautilus DevOps team.
