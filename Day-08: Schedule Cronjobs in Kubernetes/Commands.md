# Nautilus CronJob - Command Reference

## Quick Command Reference

This document provides a comprehensive list of commands for managing and monitoring the Nautilus CronJob in Kubernetes.

---

## Deployment Commands

### Apply the CronJob
```bash
kubectl apply -f nautilus-cronjob.yaml
```

### Apply with Verbose Output
```bash
kubectl apply -f nautilus-cronjob.yaml --validate=true
```

### Dry Run (Test Without Applying)
```bash
kubectl apply -f nautilus-cronjob.yaml --dry-run=client
```

---

## Viewing CronJob Information

### List All CronJobs
```bash
kubectl get cronjobs
```

### Get Specific CronJob
```bash
kubectl get cronjob nautilus
```

### Get CronJob with Wide Output
```bash
kubectl get cronjob nautilus -o wide
```

### Describe CronJob (Detailed Information)
```bash
kubectl describe cronjob nautilus
```

### View CronJob YAML
```bash
kubectl get cronjob nautilus -o yaml
```

### View CronJob JSON
```bash
kubectl get cronjob nautilus -o json
```

---

## Job Management

### List All Jobs
```bash
kubectl get jobs
```

### List Jobs with Labels
```bash
kubectl get jobs --show-labels
```

### Watch Jobs in Real-Time
```bash
kubectl get jobs -w
```

### Describe a Specific Job
```bash
kubectl describe job <job-name>
```

### Get Job YAML
```bash
kubectl get job <job-name> -o yaml
```

---

## Pod Management

### List Pods Created by Jobs
```bash
kubectl get pods
```

### List Pods with Selector
```bash
kubectl get pods --selector=job-name=<job-name>
```

### Describe Pod
```bash
kubectl describe pod <pod-name>
```

### Get Pod Logs
```bash
kubectl logs <pod-name>
```

### Get Logs from Job (Latest Pod)
```bash
kubectl logs job/<job-name>
```

### Follow Logs in Real-Time
```bash
kubectl logs -f <pod-name>
```

### Get Previous Pod Logs (If Restarted)
```bash
kubectl logs <pod-name> --previous
```

---

## Manual Testing

### Create Manual Job from CronJob
```bash
kubectl create job --from=cronjob/nautilus nautilus-manual-test
```

### Create Manual Job with Custom Name
```bash
kubectl create job --from=cronjob/nautilus nautilus-test-$(date +%s)
```

### View Manual Test Logs
```bash
kubectl logs job/nautilus-manual-test
```

### Delete Manual Test Job
```bash
kubectl delete job nautilus-manual-test
```

---

## CronJob Control

### Suspend CronJob (Stop Creating New Jobs)
```bash
kubectl patch cronjob nautilus -p '{"spec":{"suspend":true}}'
```

### Resume CronJob
```bash
kubectl patch cronjob nautilus -p '{"spec":{"suspend":false}}'
```

### Check Suspend Status
```bash
kubectl get cronjob nautilus -o jsonpath='{.spec.suspend}'
```

---

## Editing and Updating

### Edit CronJob Interactively
```bash
kubectl edit cronjob nautilus
```

### Update Schedule
```bash
kubectl patch cronjob nautilus -p '{"spec":{"schedule":"*/10 * * * *"}}'
```

### Update Container Image
```bash
kubectl patch cronjob nautilus -p '{"spec":{"jobTemplate":{"spec":{"template":{"spec":{"containers":[{"name":"cron-nautilus","image":"nginx:1.25"}]}}}}}}'
```

### Replace CronJob Configuration
```bash
kubectl replace -f nautilus-cronjob.yaml
```

---

## Deletion Commands

### Delete CronJob
```bash
kubectl delete cronjob nautilus
```

### Delete CronJob and Wait for Completion
```bash
kubectl delete cronjob nautilus --wait=true
```

### Delete Specific Job
```bash
kubectl delete job <job-name>
```

### Delete All Jobs Created by CronJob
```bash
kubectl delete jobs -l job-name
```

### Delete All Completed Jobs
```bash
kubectl delete jobs --field-selector status.successful=1
```

### Delete All Failed Jobs
```bash
kubectl delete jobs --field-selector status.failed=1
```

---

## Monitoring and Debugging

### Get Events Related to CronJob
```bash
kubectl get events --field-selector involvedObject.name=nautilus
```

### Get Events Sorted by Timestamp
```bash
kubectl get events --sort-by='.metadata.creationTimestamp'
```

### Watch Events in Real-Time
```bash
kubectl get events -w
```

### Check Resource Usage (if metrics-server installed)
```bash
kubectl top pod <pod-name>
```

### Get Job Status
```bash
kubectl get jobs -o jsonpath='{.items[*].status}'
```

### Count Active Jobs
```bash
kubectl get jobs --field-selector status.active=1 --no-headers | wc -l
```

### Count Successful Jobs
```bash
kubectl get jobs --field-selector status.successful=1 --no-headers | wc -l
```

### Count Failed Jobs
```bash
kubectl get jobs --field-selector status.failed=1 --no-headers | wc -l
```

---

## Advanced Queries

### Get CronJob Last Schedule Time
```bash
kubectl get cronjob nautilus -o jsonpath='{.status.lastScheduleTime}'
```

### Get Active Jobs Count
```bash
kubectl get cronjob nautilus -o jsonpath='{.status.active}'
```

### List All Jobs with Creation Timestamp
```bash
kubectl get jobs -o custom-columns=NAME:.metadata.name,CREATED:.metadata.creationTimestamp
```

### Get Job Completion Time
```bash
kubectl get job <job-name> -o jsonpath='{.status.completionTime}'
```

### Get Pod Status Reason
```bash
kubectl get pods -o jsonpath='{.items[*].status.containerStatuses[*].state}'
```

---

## Troubleshooting Commands

### Check CronJob Configuration Syntax
```bash
kubectl apply -f nautilus-cronjob.yaml --dry-run=server
```

### Validate YAML Syntax
```bash
kubectl apply -f nautilus-cronjob.yaml --validate=strict --dry-run=client
```

### Get Pod Status Details
```bash
kubectl get pods -o wide
```

### Debug Pod Issues
```bash
kubectl describe pod <pod-name>
```

### Get Container Exit Code
```bash
kubectl get pod <pod-name> -o jsonpath='{.status.containerStatuses[0].state.terminated.exitCode}'
```

### Check Resource Quotas
```bash
kubectl get resourcequotas
```

### Check Limit Ranges
```bash
kubectl get limitranges
```

---

## Export and Backup

### Export CronJob to File
```bash
kubectl get cronjob nautilus -o yaml > nautilus-cronjob-backup.yaml
```

### Export All Jobs
```bash
kubectl get jobs -o yaml > all-jobs-backup.yaml
```

### Export CronJob with Timestamp
```bash
kubectl get cronjob nautilus -o yaml > nautilus-cronjob-$(date +%Y%m%d-%H%M%S).yaml
```

---

## Namespace Operations

### Get CronJobs in Specific Namespace
```bash
kubectl get cronjobs -n <namespace>
```

### Get CronJobs in All Namespaces
```bash
kubectl get cronjobs -A
```

### Create CronJob in Specific Namespace
```bash
kubectl apply -f nautilus-cronjob.yaml -n <namespace>
```

---

## Cleanup Commands

### Delete All Completed Pods
```bash
kubectl delete pods --field-selector=status.phase==Succeeded
```

### Delete All Failed Pods
```bash
kubectl delete pods --field-selector=status.phase==Failed
```

### Force Delete Stuck Pod
```bash
kubectl delete pod <pod-name> --force --grace-period=0
```

### Clean Up Everything Related to Nautilus
```bash
kubectl delete cronjob nautilus
kubectl delete jobs -l job-name
kubectl delete pods -l job-name
```

---

## Useful Aliases (Add to ~/.bashrc or ~/.zshrc)

```bash
# CronJob aliases
alias kgcj='kubectl get cronjobs'
alias kdcj='kubectl describe cronjob'
alias kdelcj='kubectl delete cronjob'

# Job aliases
alias kgj='kubectl get jobs'
alias kdj='kubectl describe job'
alias kdelj='kubectl delete job'

# Log aliases
alias klogs='kubectl logs'
alias klogsf='kubectl logs -f'

# General aliases
alias k='kubectl'
alias kga='kubectl get all'
alias kdel='kubectl delete'
```

---

## Common Workflows

### Check if CronJob is Running Properly
```bash
kubectl get cronjob nautilus
kubectl describe cronjob nautilus | grep "Last Schedule"
kubectl get jobs | grep nautilus
```

### Investigate Failed Job
```bash
kubectl get jobs
kubectl describe job <failed-job-name>
kubectl get pods -l job-name=<failed-job-name>
kubectl logs <pod-name>
```

### Quick Status Check
```bash
echo "CronJob Status:" && kubectl get cronjob nautilus
echo -e "\nRecent Jobs:" && kubectl get jobs --sort-by=.metadata.creationTimestamp | tail -5
echo -e "\nRecent Pods:" && kubectl get pods --sort-by=.metadata.creationTimestamp | tail -5
```

---

## Notes

- Replace `<job-name>` and `<pod-name>` with actual names from your cluster
- Most commands can be shortened using aliases (e.g., `kubectl` → `k`)
- Use `-n <namespace>` flag to operate on different namespaces
- Add `--watch` or `-w` to monitor resources in real-time
- Use `--help` with any command for more options

---

**Last Updated**: October 2025
