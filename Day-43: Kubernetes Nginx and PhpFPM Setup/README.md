# Nginx + PHP-FPM Kubernetes Deployment

This repository contains Kubernetes manifests for deploying a PHP application using Nginx as a web server and PHP-FPM as the PHP processor.

## Architecture Overview

The deployment consists of:
- **Nginx Container**: Serves static files and proxies PHP requests
- **PHP-FPM Container**: Processes PHP scripts
- **Shared Volume**: emptyDir volume shared between both containers
- **NodePort Service**: Exposes the application externally

## Components

### 1. ConfigMap (`nginx-config`)
Custom Nginx configuration with the following modifications:
- Listening port: `8092` (changed from default 80)
- Document root: `/var/www/html` (changed from `/usr/share/nginx`)
- Directory index: `index index.html index.htm index.php`
- PHP-FPM proxy configuration for `.php` files

### 2. Pod (`nginx-phpfpm`)
Multi-container pod with:
- **nginx-container**: 
  - Image: `nginx:latest`
  - Port: `8092`
  - Volumes: shared-files, nginx-config-volume
  
- **php-fpm-container**:
  - Image: `php:8.1-fpm-alpine`
  - Volumes: shared-files

### 3. Service (`nginx-phpfpm-service`)
- Type: `NodePort`
- NodePort: `30012`
- Target Port: `8092`

## Prerequisites

- Kubernetes cluster (configured and running)
- `kubectl` utility configured to access the cluster
- `/opt/index.php` file available on the jump host

## Deployment Instructions

### Step 1: Create the Kubernetes Resources

Save the YAML configuration to a file:

```bash
cat > nginx-phpfpm-deployment.yaml << 'EOF'
# Paste the YAML content here
EOF
```

Apply the configuration:

```bash
kubectl apply -f nginx-phpfpm-deployment.yaml
```

### Step 2: Verify Deployment

Check if all resources are created:

```bash
# Check ConfigMap
kubectl get configmap nginx-config

# Check Pod
kubectl get pod nginx-phpfpm

# Check Service
kubectl get svc nginx-phpfpm-service
```

Wait for the pod to be in Running state:

```bash
kubectl wait --for=condition=Ready pod/nginx-phpfpm --timeout=120s
```

Check pod details:

```bash
kubectl describe pod nginx-phpfpm
```

### Step 3: Copy PHP Application Files

Copy the index.php file to the nginx container:

```bash
kubectl cp /opt/index.php nginx-phpfpm:/var/www/html/index.php -c nginx-container
```

Verify the file was copied:

```bash
kubectl exec nginx-phpfpm -c nginx-container -- ls -la /var/www/html/
```

### Step 4: Access the Application

The application is now accessible via:
- **NodePort**: `http://<node-ip>:30012`
- Use the **App** button in the interface to access the application

## Verification Commands

### Check Pod Status
```bash
kubectl get pod nginx-phpfpm
```

Expected output:
```
NAME           READY   STATUS    RESTARTS   AGE
nginx-phpfpm   2/2     Running   0          1m
```

### Check Container Logs

Nginx logs:
```bash
kubectl logs nginx-phpfpm -c nginx-container
```

PHP-FPM logs:
```bash
kubectl logs nginx-phpfpm -c php-fpm-container
```

### Test from Inside the Pod

Execute commands in the nginx container:
```bash
kubectl exec -it nginx-phpfpm -c nginx-container -- /bin/sh
```

Execute commands in the php-fpm container:
```bash
kubectl exec -it nginx-phpfpm -c php-fpm-container -- /bin/sh
```

### Test PHP Processing

Create a test PHP file:
```bash
kubectl exec nginx-phpfpm -c nginx-container -- sh -c 'echo "<?php phpinfo(); ?>" > /var/www/html/info.php'
```

Access it via: `http://<node-ip>:30012/info.php`

## Troubleshooting

### Pod Not Starting

Check pod events:
```bash
kubectl describe pod nginx-phpfpm
```

### Configuration Issues

View the nginx configuration:
```bash
kubectl exec nginx-phpfpm -c nginx-container -- cat /etc/nginx/nginx.conf
```

### PHP-FPM Connection Issues

Check if PHP-FPM is listening:
```bash
kubectl exec nginx-phpfpm -c php-fpm-container -- netstat -tlnp
```

### Service Not Accessible

Check service endpoints:
```bash
kubectl get endpoints nginx-phpfpm-service
```

Check NodePort:
```bash
kubectl get svc nginx-phpfpm-service
```

## Cleanup

To remove all resources:

```bash
kubectl delete -f nginx-phpfpm-deployment.yaml
```

Or delete individually:

```bash
kubectl delete service nginx-phpfpm-service
kubectl delete pod nginx-phpfpm
kubectl delete configmap nginx-config
```

## Configuration Customization

### Modify Nginx Configuration

Edit the ConfigMap:
```bash
kubectl edit configmap nginx-config
```

After changes, restart the pod:
```bash
kubectl delete pod nginx-phpfpm
kubectl apply -f nginx-phpfpm-deployment.yaml
```

### Change NodePort

Edit the service specification in the YAML file and change the `nodePort` value, then reapply:
```bash
kubectl apply -f nginx-phpfpm-deployment.yaml
```

## Notes

- The `shared-files` volume is an `emptyDir` volume, meaning data is lost when the pod is deleted
- Both containers must be in `Running` state before the application is accessible
- The nginx container proxies PHP requests to PHP-FPM via localhost:9000
- Custom labels can be used as per requirements

## References

- [Kubernetes ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/)
- [Kubernetes Pods](https://kubernetes.io/docs/concepts/workloads/pods/)
- [Kubernetes Services](https://kubernetes.io/docs/concepts/services-networking/service/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [PHP-FPM Documentation](https://www.php.net/manual/en/install.fpm.php)
