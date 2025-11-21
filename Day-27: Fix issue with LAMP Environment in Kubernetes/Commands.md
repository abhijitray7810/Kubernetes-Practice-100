# LAMP WordPress Stack Troubleshooting Guide

## Problem Description

WordPress installation on Kubernetes LAMP stack became inaccessible. Application logs indicate database connectivity issues along with other problems.

## Environment Details

- **Deployment**: `lamp-wp`
- **Service**: `lamp-service`
- **Apache Port**: 80 (HTTP default)
- **NodePort**: 30008
- **Required Environment Variables**:
  - `MYSQL_ROOT_PASSWORD`
  - `MYSQL_DATABASE`
  - `MYSQL_USER`
  - `MYSQL_PASSWORD`
  - `MYSQL_HOST`

## Common Issues to Check

### 1. Database Connectivity Problems

**Symptoms**:
- WordPress shows "Error establishing database connection"
- Application logs show MySQL connection failures

**Possible Causes**:
- Incorrect `MYSQL_HOST` environment variable
- Missing or mismatched database credentials
- MySQL container not running
- Network policy blocking communication

### 2. Environment Variable Issues

**Check current environment variables**:
```bash
kubectl exec -it deployment/lamp-wp -c httpd-php-container -- printenv | grep MYSQL
```

**Common mistakes**:
- Typos in environment variable names
- Wrong container name specified
- Missing environment variables

### 3. Service Configuration Issues

**Check service configuration**:
```bash
kubectl get svc lamp-service -o yaml
```

**Common problems**:
- Wrong selector labels
- Incorrect port mapping
- NodePort conflicts

### 4. Pod Status Issues

**Check pod status**:
```bash
kubectl get pods -l app=lamp-wp
kubectl describe pod <pod-name>
kubectl logs <pod-name> -c httpd-php-container
kubectl logs <pod-name> -c mysql-container
```

## Troubleshooting Steps

### Step 1: Verify Pod Status
```bash
kubectl get pods
kubectl describe deployment lamp-wp
```

### Step 2: Check Container Names
```bash
kubectl get pod <pod-name> -o jsonpath='{.spec.containers[*].name}'
```

### Step 3: Verify Environment Variables
```bash
kubectl get deployment lamp-wp -o yaml | grep -A 20 env:
```

### Step 4: Check Service Configuration
```bash
kubectl get svc lamp-service
kubectl describe svc lamp-service
```

### Step 5: Test Database Connectivity
```bash
# From PHP container
kubectl exec -it deployment/lamp-wp -c httpd-php-container -- bash
# Inside container:
ping mysql-service-name
telnet mysql-host 3306
```

### Step 6: Review Logs
```bash
kubectl logs deployment/lamp-wp -c httpd-php-container --tail=50
kubectl logs deployment/lamp-wp -c mysql-container --tail=50
```

## Common Fixes

### Fix 1: Correct Environment Variables in Deployment

If environment variables are missing or incorrect:
```bash
kubectl edit deployment lamp-wp
```

Ensure the following environment variables are set correctly:
```yaml
env:
- name: MYSQL_ROOT_PASSWORD
  value: "<correct-password>"
- name: MYSQL_DATABASE
  value: "<database-name>"
- name: MYSQL_USER
  value: "<username>"
- name: MYSQL_PASSWORD
  value: "<user-password>"
- name: MYSQL_HOST
  value: "<mysql-service-name-or-ip>"
```

### Fix 2: Correct Service Selector

If service selector doesn't match pod labels:
```bash
kubectl edit svc lamp-service
```

Ensure selector matches deployment labels:
```yaml
selector:
  app: lamp-wp
```

### Fix 3: Restart Deployment
```bash
kubectl rollout restart deployment lamp-wp
kubectl rollout status deployment lamp-wp
```

## Verification Steps

After applying fixes:

1. **Check pod status**:
   ```bash
   kubectl get pods -w
   ```

2. **Verify service endpoints**:
   ```bash
   kubectl get endpoints lamp-service
   ```

3. **Test NodePort access**:
   ```bash
   curl http://<node-ip>:30008
   ```

4. **Check application logs**:
   ```bash
   kubectl logs deployment/lamp-wp -c httpd-php-container --tail=20
   ```

## Important Notes

- **DO NOT** delete or modify: deployment name, service name, service types, or labels
- **DO NOT** change NodePort (30008)
- **DO NOT** change Apache port (80)
- Always backup configurations before making changes
- Use `kubectl edit` for in-place modifications
- Monitor pod status after changes with `kubectl get pods -w`

## Quick Reference Commands

```bash
# Get all resources
kubectl get all

# Describe deployment
kubectl describe deployment lamp-wp

# Get deployment YAML
kubectl get deployment lamp-wp -o yaml

# Edit deployment
kubectl edit deployment lamp-wp

# Edit service
kubectl edit svc lamp-service

# Check logs
kubectl logs -f deployment/lamp-wp -c httpd-php-container

# Execute commands in container
kubectl exec -it deployment/lamp-wp -c httpd-php-container -- bash

# Restart deployment
kubectl rollout restart deployment lamp-wp
```

## Success Criteria

- All pods in `Running` state
- No errors in application logs
- WordPress installation page accessible at `http://<node-ip>:30008`
- Database connection successful
- All environment variables properly set
