# LAMP Stack on Kubernetes

## 📋 Overview

This project deploys a complete LAMP (Linux, Apache, MySQL, PHP) stack on Kubernetes cluster. The deployment consists of an Apache web server with PHP support and MySQL database, running as separate containers within the same pod.

## 🏗️ Architecture

```
┌─────────────────────────────────────────┐
│         Kubernetes Cluster              │
│                                         │
│  ┌───────────────────────────────────┐ │
│  │      Pod: lamp-wp                 │ │
│  │                                   │ │
│  │  ┌─────────────────────────────┐ │ │
│  │  │ httpd-php-container         │ │ │
│  │  │ (webdevops/php-apache)      │ │ │
│  │  │ Port: 80                    │ │ │
│  │  │ Document Root: /app         │ │ │
│  │  └─────────────────────────────┘ │ │
│  │                                   │ │
│  │  ┌─────────────────────────────┐ │ │
│  │  │ mysql-container             │ │ │
│  │  │ (mysql:5.6)                 │ │ │
│  │  │ Port: 3306                  │ │ │
│  │  └─────────────────────────────┘ │ │
│  └───────────────────────────────────┘ │
│                                         │
│  Services:                              │
│  • lamp-service (NodePort: 30008)      │
│  • mysql-service (ClusterIP: 3306)     │
└─────────────────────────────────────────┘
```

## 📦 Components

### 1. ConfigMap
- **Name**: `php-config`
- **Purpose**: Configures PHP settings
- **Content**: `variables_order = "EGPCS"`
- **Mount Path**: `/opt/docker/etc/php/php.ini`

### 2. Secret
- **Name**: `mysql-secrets`
- **Type**: Opaque
- **Contains**:
  - `MYSQL_ROOT_PASSWORD`: Root password for MySQL
  - `MYSQL_DATABASE`: Database name
  - `MYSQL_USER`: MySQL user
  - `MYSQL_PASSWORD`: MySQL user password
  - `MYSQL_HOST`: MySQL service hostname

### 3. Deployment
- **Name**: `lamp-wp`
- **Replicas**: 1
- **Containers**:
  - **httpd-php-container**: 
    - Image: `webdevops/php-apache:alpine-3-php7`
    - Port: 80
    - Environment variables from secrets
  - **mysql-container**: 
    - Image: `mysql:5.6`
    - Port: 3306
    - Environment variables from secrets

### 4. Services
- **lamp-service**:
  - Type: NodePort
  - Port: 80
  - NodePort: 30008
  - Exposes the web application
  
- **mysql-service**:
  - Type: ClusterIP
  - Port: 3306
  - Internal database service

## 🚀 Quick Start

### Prerequisites
- Kubernetes cluster running
- `kubectl` configured on jump_host
- Access to jump_host server
- `/tmp/index.php` file exists

### Installation Steps

#### Step 1: Deploy Kubernetes Resources
```bash
kubectl apply -f lamp-deployment.yaml
```

#### Step 2: Wait for Deployment
```bash
# Watch until pod is running with 2/2 containers ready
kubectl get pods -l app=lamp-wp -w
```

#### Step 3: Get Pod Name
```bash
POD_NAME=$(kubectl get pods -l app=lamp-wp -o jsonpath='{.items[0].metadata.name}')
echo "Pod Name: $POD_NAME"
```

#### Step 4: Prepare index.php
Create or modify `/tmp/index.php` to use environment variables:

```php
<?php
$dbname = getenv('MYSQL_DATABASE');
$dbuser = getenv('MYSQL_USER');
$dbpass = getenv('MYSQL_PASSWORD');
$dbhost = getenv('MYSQL_HOST');

$conn = mysqli_connect($dbhost, $dbuser, $dbpass, $dbname);

if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}
echo "Connected successfully";
mysqli_close($conn);
?>
```

#### Step 5: Copy index.php to Container
```bash
kubectl cp /tmp/index.php $POD_NAME:/app/index.php -c httpd-php-container
```

#### Step 6: Access the Application
```bash
# Get node IP
kubectl get nodes -o wide

# Access the application
# http://<node-ip>:30008/index.php
```

Expected output: **"Connected successfully"**

## 📝 Automated Deployment Script

Save the following as `deploy-lamp.sh`:

```bash
#!/bin/bash

echo "======================================"
echo "LAMP Stack Kubernetes Deployment"
echo "======================================"

kubectl apply -f lamp-deployment.yaml

echo "Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=lamp-wp --timeout=120s

POD_NAME=$(kubectl get pods -l app=lamp-wp -o jsonpath='{.items[0].metadata.name}')
echo "Pod name: $POD_NAME"

echo "Waiting for MySQL to initialize..."
sleep 30

cat > /tmp/index.php << 'EOF'
<?php
$dbname = getenv('MYSQL_DATABASE');
$dbuser = getenv('MYSQL_USER');
$dbpass = getenv('MYSQL_PASSWORD');
$dbhost = getenv('MYSQL_HOST');

$conn = mysqli_connect($dbhost, $dbuser, $dbpass, $dbname);

if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}
echo "Connected successfully";
mysqli_close($conn);
?>
EOF

kubectl cp /tmp/index.php $POD_NAME:/app/index.php -c httpd-php-container

echo "Deployment complete!"
kubectl get pods -l app=lamp-wp
kubectl get svc lamp-service mysql-service
```

Run it:
```bash
chmod +x deploy-lamp.sh
./deploy-lamp.sh
```

## 🔍 Verification Commands

### Check All Resources
```bash
# Check ConfigMap
kubectl get configmap php-config

# Check Secrets
kubectl get secret mysql-secrets

# Check Deployment
kubectl get deployment lamp-wp

# Check Pods
kubectl get pods -l app=lamp-wp

# Check Services
kubectl get svc lamp-service mysql-service
```

### Detailed Information
```bash
# Describe deployment
kubectl describe deployment lamp-wp

# Describe pod
kubectl describe pod -l app=lamp-wp

# Check logs
kubectl logs $POD_NAME -c httpd-php-container
kubectl logs $POD_NAME -c mysql-container
```

### Test Environment Variables
```bash
# Check env vars in httpd container
kubectl exec $POD_NAME -c httpd-php-container -- env | grep MYSQL

# Test PHP MySQL connection
kubectl exec -it $POD_NAME -c httpd-php-container -- php -r "
\$conn = mysqli_connect(getenv('MYSQL_HOST'), getenv('MYSQL_USER'), getenv('MYSQL_PASSWORD'), getenv('MYSQL_DATABASE'));
if (\$conn) { 
    echo 'MySQL connection: SUCCESS\n'; 
    mysqli_close(\$conn);
} else { 
    echo 'MySQL connection: FAILED - ' . mysqli_connect_error() . '\n'; 
}
"
```

### Verify File Copy
```bash
# List files in /app directory
kubectl exec $POD_NAME -c httpd-php-container -- ls -la /app/

# View index.php content
kubectl exec $POD_NAME -c httpd-php-container -- cat /app/index.php
```

## 🐛 Troubleshooting

### Pod Not Starting
```bash
# Check pod events
kubectl describe pod -l app=lamp-wp

# Check container logs
kubectl logs $POD_NAME -c httpd-php-container --tail=50
kubectl logs $POD_NAME -c mysql-container --tail=50
```

### MySQL Connection Issues
```bash
# Verify MySQL is running
kubectl exec $POD_NAME -c mysql-container -- mysqladmin ping -h localhost -p$(kubectl get secret mysql-secrets -o jsonpath='{.data.MYSQL_ROOT_PASSWORD}' | base64 -d)

# Check MySQL logs
kubectl logs $POD_NAME -c mysql-container

# Wait longer - MySQL needs 30-60 seconds to initialize
sleep 30
```

### Can't Access NodePort 30008
```bash
# Verify service configuration
kubectl get svc lamp-service -o yaml

# Check if port is open
kubectl get svc lamp-service

# Get node IP
kubectl get nodes -o wide

# Test from within cluster
kubectl run test-pod --image=busybox --rm -it --restart=Never -- wget -O- http://lamp-service/index.php
```

### Environment Variables Not Set
```bash
# Verify secret exists
kubectl get secret mysql-secrets -o yaml

# Check if env vars are in pod spec
kubectl get pod $POD_NAME -o yaml | grep -A 10 env:

# Test from inside container
kubectl exec $POD_NAME -c httpd-php-container -- printenv | grep MYSQL
```

### File Not Found (404 Error)
```bash
# Verify file was copied
kubectl exec $POD_NAME -c httpd-php-container -- ls -la /app/

# Check Apache document root
kubectl exec $POD_NAME -c httpd-php-container -- grep DocumentRoot /opt/docker/etc/httpd/vhost.conf

# Copy file again
kubectl cp /tmp/index.php $POD_NAME:/app/index.php -c httpd-php-container
```

## 🔧 Configuration

### Modifying MySQL Credentials
Edit the `mysql-secrets` section in `lamp-deployment.yaml`:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secrets
type: Opaque
stringData:
  MYSQL_ROOT_PASSWORD: "your-root-password"
  MYSQL_DATABASE: "your-database"
  MYSQL_USER: "your-user"
  MYSQL_PASSWORD: "your-password"
  MYSQL_HOST: "mysql-service"
```

Then apply:
```bash
kubectl apply -f lamp-deployment.yaml
kubectl rollout restart deployment lamp-wp
```

### Changing NodePort
Edit the `lamp-service` section:
```yaml
spec:
  type: NodePort
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30008  # Change this value (must be 30000-32767)
```

### Scaling the Deployment
```bash
kubectl scale deployment lamp-wp --replicas=2
```

**Note**: Multiple replicas will have separate MySQL instances (not recommended for production).

## 📊 Resource Requirements

### Default Resources
- **httpd-php-container**: No limits set (uses node defaults)
- **mysql-container**: No limits set (uses node defaults)

### Recommended for Production
Add resource limits to the deployment:

```yaml
resources:
  requests:
    memory: "256Mi"
    cpu: "250m"
  limits:
    memory: "512Mi"
    cpu: "500m"
```

## 🧹 Cleanup

### Remove All Resources
```bash
kubectl delete -f lamp-deployment.yaml
```

### Remove Specific Components
```bash
# Delete deployment only
kubectl delete deployment lamp-wp

# Delete services
kubectl delete svc lamp-service mysql-service

# Delete configmap
kubectl delete configmap php-config

# Delete secret
kubectl delete secret mysql-secrets
```

## 📚 Additional Information

### Files Structure
```
.
├── lamp-deployment.yaml    # Main Kubernetes manifest
├── deploy-lamp.sh          # Automated deployment script
├── README.md              # This file
└── /tmp/index.php         # PHP application file
```

### Environment Variables Available
All containers have access to:
- `MYSQL_ROOT_PASSWORD`
- `MYSQL_DATABASE`
- `MYSQL_USER`
- `MYSQL_PASSWORD`
- `MYSQL_HOST`

### Network Communication
- Web traffic: External → NodePort 30008 → httpd-php-container:80
- Database: httpd-php-container → mysql-service:3306 → mysql-container:3306

## 🔒 Security Notes

⚠️ **Important**: This configuration is for development/testing purposes.

For production:
1. Use stronger passwords
2. Store secrets in external secret management (e.g., Vault)
3. Add network policies
4. Enable TLS/SSL
5. Use persistent volumes for MySQL data
6. Implement resource limits
7. Add readiness and liveness probes
8. Use non-root containers

## 📞 Support

For issues or questions:
1. Check the Troubleshooting section
2. Review pod logs: `kubectl logs $POD_NAME -c <container-name>`
3. Describe resources: `kubectl describe <resource-type> <resource-name>`

## 📄 License

This configuration is provided as-is for educational and development purposes.

---

**Version**: 1.0  
**Last Updated**: December 2025  
**Kubernetes Version**: 1.20+
