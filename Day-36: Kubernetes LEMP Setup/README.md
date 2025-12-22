# Nautilus DevOps Project: LEMP Stack Deployment on Kubernetes

## Project Overview

This project deploys a static website on a Kubernetes cluster using the LEMP stack (Linux, Nginx, MySQL, PHP-FPM). The deployment includes multiple containers managed within a single pod, with proper secret management and service exposure.

## Architecture Components

- **Web Server**: Nginx with PHP-FPM (webdevops/php-nginx:alpine-3-php7)
- **Database**: MySQL 5.6
- **Orchestration**: Kubernetes
- **Configuration**: ConfigMaps and Secrets for sensitive data

## Prerequisites

- Kubernetes cluster running and accessible
- kubectl configured on the jump host
- Access to the required container images

## Deployment Steps

### 1. Create Secrets for MySQL

```bash
# Create secrets for MySQL credentials
kubectl create secret generic mysql-root-pass --from-literal=password=R00t
kubectl create secret generic mysql-user-pass --from-literal=username=kodekloud_cap --from-literal=password=ksH85UJjhb
kubectl create secret generic mysql-db-url --from-literal=database=kodekloud_db10
kubectl create secret generic mysql-host --from-literal=host=mysql-service
```

### 2. Create ConfigMap for PHP Configuration

```bash
# Create configmap for php.ini settings
kubectl create configmap php-config --from-literal=php.ini='variables_order = "EGPCS"'
```

### 3. Deploy the LEMP Stack

```bash
# Apply the deployment configuration
kubectl apply -f lemp-deployment.yaml

# Apply the service configurations
kubectl apply -f services.yaml
```

### 4. Deploy Application Files

```bash
# Copy index.php to the nginx container
POD_NAME=$(kubectl get pods -l app=lemp-wp -o jsonpath='{.items[0].metadata.name}')
kubectl cp /tmp/index.php $POD_NAME:/app/index.php -c nginx-php-container
```

## Configuration Details

### Deployment (lemp-wp)

The deployment creates a pod with two containers:

1. **nginx-php-container**:
   - Image: webdevops/php-nginx:alpine-3-php7
   - Mounts: php-config ConfigMap at `/opt/docker/etc/php/php.ini`
   - Environment variables loaded from secrets
   - Document root: `/app`

2. **mysql-container**:
   - Image: mysql:5.6
   - Environment variables loaded from secrets
   - Database initialization with provided credentials

### Environment Variables

Both containers use these environment variables (loaded from secrets):
- `MYSQL_ROOT_PASSWORD`: Root password for MySQL
- `MYSQL_DATABASE`: Database name
- `MYSQL_USER`: Application database user
- `MYSQL_PASSWORD`: Application user password
- `MYSQL_HOST`: MySQL service hostname

### Services

1. **lemp-service**:
   - Type: NodePort
   - Port: 80
   - NodePort: 30008
   - Selector: app=lemp-wp
   - Exposes the web application

2. **mysql-service**:
   - Type: ClusterIP (default)
   - Port: 3306
   - Selector: app=lemp-wp
   - Internal MySQL service for application connectivity

## Application Structure

### index.php

The main application file is located at `/app/index.php` in the nginx container. It connects to MySQL using environment variables:

```php
<?php
// Get MySQL connection details from environment variables
$mysql_host = getenv('MYSQL_HOST');
$mysql_database = getenv('MYSQL_DATABASE');
$mysql_user = getenv('MYSQL_USER');
$mysql_password = getenv('MYSQL_PASSWORD');

// Connection string
$conn = mysqli_connect($mysql_host, $mysql_user, $mysql_password, $mysql_database);

// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}
echo "Connected successfully";

// Close connection
mysqli_close($conn);
?>
```

## Accessing the Application

### Web Interface
- Access the website by clicking the "Website" button in the top bar
- Alternatively, use: `http://<node-ip>:30008`

### Verification
When accessing the application, you should see:
- Status: "Connected successfully" if database connection is established
- Any connection errors will be displayed on the page

## Monitoring and Management

### Check Deployment Status

```bash
# View all resources
kubectl get all -l app=lemp-wp

# Check pod status
kubectl get pods

# View pod logs
kubectl logs <pod-name> -c nginx-php-container
kubectl logs <pod-name> -c mysql-container

# Check services
kubectl get services
```

### Troubleshooting

1. **Website not accessible**:
   - Check if NodePort service is running: `kubectl get svc lemp-service`
   - Verify pods are running: `kubectl get pods`
   - Check pod logs for errors

2. **Database connection issues**:
   - Verify MySQL container is running
   - Check environment variables are correctly set
   - Verify secrets exist: `kubectl get secrets`

3. **Application errors**:
   - Check nginx container logs
   - Verify index.php file is in correct location
   - Confirm PHP configuration is mounted correctly

## Security Notes

1. **Secrets Management**:
   - All sensitive data is stored in Kubernetes Secrets
   - No hardcoded credentials in configuration files
   - Environment variables are used to inject secrets

2. **Network Security**:
   - MySQL service is only exposed internally
   - Web application uses NodePort for external access
   - Internal communication between containers uses localhost

## Cleanup

To remove the deployment:

```bash
# Delete deployment and services
kubectl delete deployment lemp-wp
kubectl delete service lemp-service mysql-service

# Delete secrets (optional)
kubectl delete secret mysql-root-pass mysql-user-pass mysql-db-url mysql-host

# Delete configmap (optional)
kubectl delete configmap php-config
```

## File Structure

```
.
├── lemp-deployment.yaml    # Deployment configuration
├── services.yaml          # Service configurations
├── /tmp/index.php        # Application source file
└── README.md             # This documentation
```

## Success Criteria

The deployment is successful when:
1. All pods are in "Running" state
2. Services are created and accessible
3. Website shows "Connected successfully" message
4. Database connection is established properly

## Support

For issues or questions:
1. Check pod logs for specific error messages
2. Verify all secrets and configmaps exist
3. Ensure kubectl is properly configured
4. Confirm network connectivity between components
