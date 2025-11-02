# Nginx PHP-FPM Kubernetes Troubleshooting Guide

## Overview

This guide provides step-by-step instructions to troubleshoot and fix an Nginx and PHP-FPM setup running in a Kubernetes cluster. The issue involves a pod named `nginx-phpfpm` that has halted its functionality due to configuration problems.

## Problem Statement

The Nginx and PHP-FPM setup on the Kubernetes cluster encountered an issue that stopped it from working properly. The pod contains two containers:
- `nginx-container`: Serves web requests
- `php-fpm-container`: Processes PHP scripts

## Environment Details

- **Pod Name**: `nginx-phpfpm`
- **ConfigMap Name**: `nginx-config`
- **Jump Host**: Pre-configured with `kubectl` utility
- **Document Root**: `/var/www/html`
- **PHP File Location**: `/home/thor/index.php` (on jump host)

## Prerequisites

- Access to the jump host
- `kubectl` command-line tool configured
- Appropriate permissions to modify ConfigMaps and Pods

## Architecture

```
┌─────────────────────────────────────┐
│         nginx-phpfpm Pod            │
│                                     │
│  ┌──────────────┐  ┌─────────────┐ │
│  │   nginx      │  │  php-fpm    │ │
│  │  container   │─▶│  container  │ │
│  │  (port 80)   │  │  (port 9000)│ │
│  └──────────────┘  └─────────────┘ │
│                                     │
│  Volume: /var/www/html              │
└─────────────────────────────────────┘
         ▲
         │
    nginx-config
    (ConfigMap)
```

## Common Issues

The most frequent issues with Nginx-PHP-FPM setups include:

1. **Incorrect FastCGI Pass Configuration**: Wrong hostname/port in `fastcgi_pass` directive
2. **Missing or Incorrect SCRIPT_FILENAME**: PHP-FPM cannot locate PHP files
3. **Permission Issues**: Files not readable by nginx/php-fpm users
4. **Port Mismatch**: PHP-FPM listening on different port than nginx expects
5. **Missing FastCGI Parameters**: Required parameters not passed to PHP-FPM

## Solution Steps

### 1. Diagnose the Problem

First, identify what's causing the issue:

```bash
# Check pod status
kubectl get pods nginx-phpfpm

# View container logs
kubectl logs nginx-phpfpm -c nginx-container
kubectl logs nginx-phpfpm -c php-fpm-container

# Examine the configmap
kubectl get configmap nginx-config -o yaml
```

### 2. Fix the Configuration

The typical fix involves correcting the Nginx configuration in the ConfigMap:

```bash
# Edit the configmap
kubectl edit configmap nginx-config
```

**Key configuration points to verify:**
- `fastcgi_pass` should be `127.0.0.1:9000` (or `localhost:9000`)
- `fastcgi_param SCRIPT_FILENAME` should be `$document_root$fastcgi_script_name`
- Document root should match between nginx and php-fpm
- FastCGI parameters should be included

### 3. Apply Changes

Restart the pod to apply the new configuration:

```bash
# Delete the pod (it will be recreated)
kubectl delete pod nginx-phpfpm

# Wait for it to be ready
kubectl wait --for=condition=ready pod/nginx-phpfpm --timeout=60s
```

### 4. Deploy Application

Copy the PHP file to the container:

```bash
# Copy index.php from jump host to nginx container
kubectl cp /home/thor/index.php nginx-phpfpm:/var/www/html/index.php -c nginx-container

# Verify the file
kubectl exec nginx-phpfpm -c nginx-container -- ls -la /var/www/html/
```

### 5. Verify the Fix

Test that everything is working:

```bash
# Check nginx configuration syntax
kubectl exec nginx-phpfpm -c nginx-container -- nginx -t

# Verify PHP-FPM is running
kubectl exec nginx-phpfpm -c php-fpm-container -- ps aux | grep php-fpm

# Access the website using the "Website" button
```

## Correct Nginx Configuration Example

```nginx
events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    
    server {
        listen 80;
        index index.php index.html;
        root /var/www/html;
        
        location ~ \.php$ {
            include fastcgi_params;
            fastcgi_pass 127.0.0.1:9000;
            fastcgi_index index.php;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        }
    }
}
```

## Quick Start

For a fast resolution, follow these commands in sequence:

```bash
# 1. Check the issue
kubectl get pods nginx-phpfpm
kubectl logs nginx-phpfpm -c nginx-container

# 2. Fix the configmap
kubectl edit configmap nginx-config
# (Make necessary corrections)

# 3. Restart the pod
kubectl delete pod nginx-phpfpm
kubectl wait --for=condition=ready pod/nginx-phpfpm --timeout=60s

# 4. Copy the PHP file
kubectl cp /home/thor/index.php nginx-phpfpm:/var/www/html/index.php -c nginx-container

# 5. Verify
kubectl exec nginx-phpfpm -c nginx-container -- ls -la /var/www/html/
```

## Troubleshooting

### Pod Not Starting
```bash
kubectl describe pod nginx-phpfpm
kubectl logs nginx-phpfpm -c nginx-container --previous
```

### 502 Bad Gateway Error
- Check PHP-FPM is running: `kubectl exec nginx-phpfpm -c php-fpm-container -- ps aux | grep php-fpm`
- Verify connection: `kubectl exec nginx-phpfpm -c nginx-container -- nc -zv 127.0.0.1 9000`

### 404 Not Found
- Verify file exists: `kubectl exec nginx-phpfpm -c nginx-container -- ls -la /var/www/html/`
- Check document root in nginx config

### Permission Denied
```bash
kubectl exec nginx-phpfpm -c nginx-container -- chmod 644 /var/www/html/index.php
kubectl exec nginx-phpfpm -c nginx-container -- chown nginx:nginx /var/www/html/index.php
```

## Files in This Repository

- **README.md**: This file - complete troubleshooting guide
- **commands.md**: Detailed command reference with examples

## Additional Resources

- [Nginx Documentation](https://nginx.org/en/docs/)
- [PHP-FPM Configuration](https://www.php.net/manual/en/install.fpm.configuration.php)
- [Kubernetes ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/)
- [Kubernetes Debugging Pods](https://kubernetes.io/docs/tasks/debug/debug-application/)

## Success Criteria

After completing these steps, you should be able to:
- ✅ Pod `nginx-phpfpm` is in `Running` state
- ✅ No errors in nginx or php-fpm logs
- ✅ `index.php` file is present in `/var/www/html/`
- ✅ Website accessible via the "Website" button
- ✅ PHP pages render correctly

## Notes

- The `kubectl` utility on the jump host is already configured to work with the cluster
- ConfigMap changes require pod restart to take effect
- Always verify the `fastcgi_pass` directive points to the correct PHP-FPM address
- Both c
