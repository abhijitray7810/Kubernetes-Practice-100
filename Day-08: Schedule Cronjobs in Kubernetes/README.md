# Nautilus CronJob - Kubernetes Periodic Task

## Overview

This repository contains the Kubernetes CronJob configuration for the Nautilus DevOps team. The CronJob executes a placeholder command on a recurring schedule as part of the initial setup for periodic task automation in the Kubernetes cluster.

## CronJob Details

- **Name**: `nautilus`
- **Schedule**: `*/7 * * * *` (Runs every 7 minutes)
- **Container Name**: `cron-nautilus`
- **Image**: `nginx:latest`
- **Command**: `echo Welcome to xfusioncorp!`
- **Restart Policy**: `OnFailure`

## Prerequisites

- Access to the Kubernetes cluster via `jump_host`
- `kubectl` utility configured and authenticated
- Appropriate permissions to create CronJob resources

## Deployment Instructions

### 1. Apply the CronJob Manifest

```bash
kubectl apply -f nautilus-cronjob.yaml
```

### 2. Verify the CronJob Creation

```bash
kubectl get cronjob nautilus
```

Expected output:
```
NAME       SCHEDULE      SUSPEND   ACTIVE   LAST SCHEDULE   AGE
nautilus   */7 * * * *   False     0        <none>          14s
```

### 3. View Detailed CronJob Information

```bash
kubectl describe cronjob nautilus
```

## Monitoring and Verification

### Check Job Executions

After the schedule triggers (wait at least 7 minutes), view created jobs:

```bash
kubectl get jobs
```

### View Job Logs

To see the output from a specific job execution:

```bash
kubectl logs job/nautilus-<timestamp>
```

Replace `<timestamp>` with the actual timestamp from the job name.

### Watch Jobs in Real-Time

Monitor job creation as it happens:

```bash
kubectl get jobs -w
```

Press `Ctrl+C` to stop watching.

## Manual Testing

To test the CronJob without waiting for the schedule:

```bash
kubectl create job --from=cronjob/nautilus nautilus-manual-test
```

View the test job logs:

```bash
kubectl logs job/nautilus-manual-test
```

Clean up the manual test job:

```bash
kubectl delete job nautilus-manual-test
```

## CronJob Schedule Format

The schedule uses standard cron format: `*/7 * * * *`

```
* * * * *
│ │ │ │ │
│ │ │ │ └─── Day of week (0-6, Sunday=0)
│ │ │ └───── Month (1-12)
│ │ └─────── Day of month (1-31)
│ └───────── Hour (0-23)
└─────────── Minute (0-59)
```

Current setting `*/7 * * * *` means: "Every 7 minutes"

## Troubleshooting

### CronJob Not Creating Jobs

1. Check if the CronJob is suspended:
   ```bash
   kubectl get cronjob nautilus -o yaml | grep suspend
   ```

2. Verify the schedule format is correct:
   ```bash
   kubectl describe cronjob nautilus
   ```

### Jobs Failing

1. Check job status:
   ```bash
   kubectl get jobs
   ```

2. Describe failed job:
   ```bash
   kubectl describe job <job-name>
   ```

3. Check pod logs:
   ```bash
   kubectl logs <pod-name>
   ```

## Maintenance Commands

### Suspend the CronJob

```bash
kubectl patch cronjob nautilus -p '{"spec":{"suspend":true}}'
```

### Resume the CronJob

```bash
kubectl patch cronjob nautilus -p '{"spec":{"suspend":false}}'
```

### Delete the CronJob

```bash
kubectl delete cronjob nautilus
```

This will also clean up all associated jobs and pods.

### Update the Schedule

Edit the CronJob:
```bash
kubectl edit cronjob nautilus
```

Or update via patch:
```bash
kubectl patch cronjob nautilus -p '{"spec":{"schedule":"*/10 * * * *"}}'
```

## Configuration History

### Job History Limits

- **Successful Job History Limit**: 3 (keeps last 3 successful jobs)
- **Failed Job History Limit**: 1 (keeps last 1 failed job)

Older jobs are automatically cleaned up by Kubernetes.

## Notes

- This is a placeholder implementation for testing periodic task execution
- The current command is a simple echo statement for validation purposes
- Replace the command with actual workload scripts as needed
- The `nginx:latest` image is used as a base container image
- Restart policy `OnFailure` ensures pods restart only on failure, not on successful completion

## Future Enhancements

- Replace placeholder command with actual business logic
- Implement proper logging and monitoring
- Add resource limits and requests
- Configure appropriate concurrency policies
- Implement alerting for job failures

## Support

For issues or questions regarding this CronJob configuration, contact the Nautilus DevOps team.

---

**Last Updated**: October 2025  
**Maintained By**: Nautilus DevOps Team
