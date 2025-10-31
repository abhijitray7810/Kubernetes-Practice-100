
# 🧰 Nginx + PHP-FPM Kubernetes Fix

## 🧩 Problem Overview
This morning, the Nginx + PHP-FPM pod (`nginx-phpfpm`) stopped serving requests.  
The issue originated from a misconfiguration in the `nginx.conf` file (stored in the `nginx-config` ConfigMap).

## ⚙️ Investigation
1. Verified the pod and container status:
   ```bash
   kubectl get pods
   kubectl describe pod nginx-phpfpm
   kubectl logs nginx-phpfpm -c nginx-container
   kubectl logs nginx-phpfpm -c php-fpm-container
````

2. Inspected the `nginx-config` ConfigMap:

   ```bash
   kubectl get configmap nginx-config -o yaml
   ```

   The PHP processing block was incorrectly configured, preventing Nginx from passing PHP requests to PHP-FPM.

## 🧠 Root Cause

`nginx.conf` lacked proper FastCGI configuration parameters and correct path handling for PHP files.

## 🧾 Fix Implemented

Edited the ConfigMap:

```bash
kubectl edit configmap nginx-config
```

Updated the Nginx configuration:

```nginx
events { }

http {
  server {
    listen 8099 default_server;
    listen [::]:8099 default_server;

    root /var/www/html;
    index index.html index.htm index.php;
    server_name _;

    location / {
      try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
      include fastcgi_params;
      fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
      fastcgi_pass 127.0.0.1:9000;
    }
  }
}
```

Then deleted the pod to reload configuration:

```bash
kubectl delete pod nginx-phpfpm
```

If the pod wasn’t recreated automatically (no controller present), it was manually recreated using:

```bash
kubectl apply -f nginx-phpfpm.yaml
```

## 📂 Copied Required File

After the pod was running, the PHP file was copied to the Nginx document root:

```bash
kubectl cp /home/thor/index.php nginx-phpfpm:/var/www/html/ -c nginx-container
```

Verification:

```bash
kubectl exec -it nginx-phpfpm -c nginx-container -- ls /var/www/html/
```

Output should show:

```
index.php
```

## ✅ Verification

Accessed the application via the **Website** button on the top bar.
The PHP page successfully loaded, confirming Nginx and PHP-FPM communication was restored.

---

### 🧾 Summary of Commands

```bash
kubectl get pods
kubectl describe pod nginx-phpfpm
kubectl get configmap nginx-config -o yaml
kubectl edit configmap nginx-config
kubectl delete pod nginx-phpfpm
kubectl apply -f nginx-phpfpm.yaml
kubectl cp /home/thor/index.php nginx-phpfpm:/var/www/html/ -c nginx-container
kubectl exec -it nginx-phpfpm -c nginx-container -- ls /var/www/html/
```

---

### 🧑‍💻 Author

**Abhijit Ray**
DevOps 365 Days — *Day 75*
[GitHub Repository](https://github.com/yourusername/devops-365days)

---

```


```
