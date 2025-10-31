# Nginx PHP-FPM Fix Commands

## Problem Summary
The nginx configuration has `root /var/www/html;` but the nginx container mounts the shared volume at `/usr/share/nginx/html`, causing a path mismatch.

## Step 1: Edit the ConfigMap

```bash
kubectl edit configmap nginx-config
```

**In the editor, change this line:**
```
root /var/www/html;
```

**To:**
```
root /usr/share/nginx/html;
```

Save and exit the editor (`:wq` in vi/vim or Ctrl+X, Y, Enter in nano)

## Step 2: Delete the Pod to Apply Changes

```bash
kubectl delete pod nginx-phpfpm
```

## Step 3: Wait for Pod to be Recreated

```bash
# Check pod status (wait until it shows 2/2 Running)
kubectl get pods nginx-phpfpm

# If not ready, wait a few seconds and check again
sleep 10
kubectl get pods nginx-phpfpm
```

## Step 4: Copy the index.php File

```bash
kubectl cp /home/thor/index.php nginx-phpfpm:/usr/share/nginx/html/index.php -c nginx-container
```

## Step 5: Verify the File was Copied

```bash
kubectl exec nginx-phpfpm -c nginx-container -- ls -la /usr/share/nginx/html/
```

## Step 6: Test the Website

```bash
# Test from inside the pod
kubectl exec nginx-phpfpm -c nginx-container -- curl -I localhost:8099/index.php

# Or test with full response
kubectl exec nginx-phpfpm -c nginx-container -- curl localhost:8099/index.php
```

## Step 7: Access via Browser

Click the **Website** button on the top bar to access the application.

---

## Complete One-Liner (After ConfigMap Edit)

```bash
kubectl delete pod nginx-phpfpm && sleep 15 && kubectl get pods nginx-phpfpm && kubectl cp /home/thor/index.php nginx-phpfpm:/usr/share/nginx/html/index.php -c nginx-container && kubectl exec nginx-phpfpm -c nginx-container -- ls -la /usr/share/nginx/html/
```

---

## Verification Commands

```bash
# Check pod is running
kubectl get pods nginx-phpfpm

# Check nginx configuration
kubectl exec nginx-phpfpm -c nginx-container -- cat /etc/nginx/nginx.conf | grep root

# Check if PHP-FPM is listening
kubectl exec nginx-phpfpm -c php-fpm-container -- netstat -tlnp 2>/dev/null | grep 9000

# Check files in document root
kubectl exec nginx-phpfpm -c nginx-container -- ls -la /usr/share/nginx/html/
```

---

## What Was Fixed

1. **Root Path Mismatch**: The nginx config pointed to `/var/www/html` but the nginx container's shared volume was mounted at `/usr/share/nginx/html`
2. **Volume Mounting**: 
   - php-fpm-container: `/var/www/html` (correct for PHP-FPM)
   - nginx-container: `/usr/share/nginx/html` (nginx needed to match this)
3. **FastCGI Configuration**: The `fastcgi_pass 127.0.0.1:9000` was correct since both containers share the same pod network namespace
