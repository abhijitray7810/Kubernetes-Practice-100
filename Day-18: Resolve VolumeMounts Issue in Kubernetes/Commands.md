
# Nginx PHP-FPM Kubernetes Troubleshooting Commands

## Step 1: Diagnose the Issue

### Check Pod Status
```bash
kubectl get pods nginx-phpfpm
```

### Get Detailed Pod Information
```bash
kubectl describe pod nginx-phpfpm
```

### View Nginx Container Logs
```bash
kubectl logs nginx-phpfpm -c nginx-container
```

### View PHP-FPM Container Logs
```bash
kubectl logs nginx-phpfpm -c php-fpm-container
```

### Check ConfigMap
```bash
kubectl get configmap nginx-config -o yaml
```

### View Nginx Configuration Inside Container
```bash
kubectl exec nginx-phpfpm -c nginx-container -- cat /etc/nginx/nginx.conf
```

---

## Step 2: Fix the ConfigMap

### Edit ConfigMap Directly
```bash
kubectl edit configmap nginx-config
```

### Or Apply Corrected ConfigMap
```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-config
data:
  nginx.conf: |
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
                fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
            }
        }
    }
EOF
```

---

## Step 3: Restart the Pod

### Delete Pod (will be recreated if managed by deployment/replicaset)
```bash
kubectl delete pod nginx-phpfpm
```

### Wait for Pod to be Ready
```bash
kubectl wait --for=condition=ready pod/nginx-phpfpm --timeout=60s
```

### Verify Pod is Running
```bash
kubectl get pods nginx-phpfpm
```

---

## Step 4: Copy index.php File

### Copy File from Jump Host to Nginx Container
```bash
kubectl cp /home/thor/index.php nginx-phpfpm:/var/www/html/index.php -c nginx-container
```

### Verify File was Copied
```bash
kubectl exec nginx-phpfpm -c nginx-container -- ls -la /var/www/html/
```

### Set Proper Permissions (if needed)
```bash
kubectl exec nginx-phpfpm -c nginx-container -- chmod 644 /var/www/html/index.php
```

---

## Step 5: Verification

### Check PHP-FPM Process
```bash
kubectl exec nginx-phpfpm -c php-fpm-container -- ps aux | grep php-fpm
```

### Test Nginx Configuration
```bash
kubectl exec nginx-phpfpm -c nginx-container -- nginx -t
```

### Reload Nginx (if needed)
```bash
kubectl exec nginx-phpfpm -c nginx-container -- nginx -s reload
```

### Check Services
```bash
kubectl get svc
```

### Test Connection to PHP-FPM from Nginx Container
```bash
kubectl exec nginx-phpfpm -c nginx-container -- nc -zv 127.0.0.1 9000
```

---

## Quick Fix Script (All-in-One)

```bash
#!/bin/bash

# Step 1: Check current status
echo "Checking pod status..."
kubectl get pods nginx-phpfpm

# Step 2: View configmap
echo "Checking configmap..."
kubectl get configmap nginx-config -o yaml

# Step 3: Edit configmap (fix fastcgi_pass if needed)
kubectl edit configmap nginx-config

# Step 4: Restart pod
echo "Restarting pod..."
kubectl delete pod nginx-phpfpm

# Step 5: Wait for pod to be ready
echo "Waiting for pod to be ready..."
kubectl wait --for=condition=ready pod/nginx-phpfpm --timeout=60s

# Step 6: Copy index.php
echo "Copying index.php..."
kubectl cp /home/thor/index.php nginx-phpfpm:/var/www/html/index.php -c nginx-container

# Step 7: Verify
echo "Verifying setup..."
kubectl exec nginx-phpfpm -c nginx-container -- ls -la /var/www/html/
kubectl logs nginx-phpfpm -c nginx-container | tail -10

echo "Done! Try accessing the website using the Website button."
```

---

## Common Issues and Solutions

### Issue: Connection refused to PHP-FPM
**Solution:** Check `fastcgi_pass` directive - should be `127.0.0.1:9000` or `localhost:9000`

### Issue: 502 Bad Gateway
**Solution:** Verify PHP-FPM is running and listening on the correct port

### Issue: 404 Not Found
**Solution:** Verify document root is `/var/www/html` and index.php exists

### Issue: File not found error
**Solution:** Check `fastcgi_param SCRIPT_FILENAME` is correctly set to `$document_root$fastcgi_script_name`
