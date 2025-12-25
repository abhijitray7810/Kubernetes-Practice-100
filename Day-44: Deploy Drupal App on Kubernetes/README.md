# Drupal on Kubernetes - Deployment Guide

This repository contains Kubernetes manifests for deploying a Drupal 8.6 application with MySQL 5.7 database backend on a Kubernetes cluster.

## Architecture Overview

The deployment consists of:
- **Drupal 8.6** web application
- **MySQL 5.7** database with persistent storage
- **Persistent Volume** for database data retention
- **Services** for internal and external connectivity

## Prerequisites

- Kubernetes cluster (v1.19+)
- `kubectl` configured to access your cluster
- Directory `/drupal-mysql-data` exists on the worker node
- Sufficient cluster resources (CPU, Memory, Storage)

## Components

### Storage
- **PersistentVolume** (`drupal-mysql-pv`): 5Gi hostPath volume at `/drupal-mysql-data`
- **PersistentVolumeClaim** (`drupal-mysql-pvc`): 3Gi claim with ReadWriteOnce access

### Secrets
- **drupal-mysql-secret**: Contains MySQL credentials
  - Root password
  - Database name
  - Database user and password

### Deployments
- **drupal-mysql**: MySQL 5.7 deployment with 1 replica
- **drupal**: Drupal 8.6 deployment with 1 replica

### Services
- **drupal-mysql-service**: ClusterIP service exposing MySQL on port 3306
- **drupal-service**: NodePort service exposing Drupal on port 30095

## Deployment Instructions

### Step 1: Clone or Create the Manifest File

Save the Kubernetes configuration as `drupal-k8s.yaml`.

### Step 2: Deploy to Kubernetes

```bash
# Apply all resources
kubectl apply -f drupal-k8s.yaml
```

### Step 3: Verify Deployment

```bash
# Check Persistent Volumes
kubectl get pv
kubectl get pvc

# Check Deployments
kubectl get deployments

# Check Pods
kubectl get pods

# Check Services
kubectl get services
```

### Step 4: Wait for Pods to be Ready

```bash
# Wait for MySQL to be ready
kubectl wait --for=condition=ready pod -l app=drupal-mysql --timeout=300s

# Wait for Drupal to be ready
kubectl wait --for=condition=ready pod -l app=drupal --timeout=300s
```

### Step 5: Check Pod Logs (Optional)

```bash
# MySQL logs
kubectl logs -l app=drupal-mysql

# Drupal logs
kubectl logs -l app=drupal
```

## Accessing Drupal

Once all pods are running, access the Drupal installation page:

```
http://<node-ip>:30095
```

Or if using the App button in your environment, simply click **App** to access the installation page.

## Drupal Installation Configuration

When you access the Drupal installation wizard, use the following database settings:

| Setting | Value |
|---------|-------|
| Database type | MySQL, MariaDB, Percona Server, or equivalent |
| Database name | `drupal` |
| Database username | `drupal` |
| Database password | `drupalpass` |
| Host | `drupal-mysql-service` |
| Port number | `3306` |
| Table name prefix | (leave empty or customize) |

### Advanced Options
Under "Advanced Options" in the database configuration:
- **Host**: `drupal-mysql-service`
- **Port**: `3306`

## Default Credentials

**MySQL Root Password**: `rootpassword` (stored in secret)

**Note**: For production deployments, change these credentials before deployment:

```bash
# Edit the secret section in drupal-k8s.yaml
# Update these values:
MYSQL_ROOT_PASSWORD: <your-secure-root-password>
MYSQL_PASSWORD: <your-secure-drupal-password>
```

## Troubleshooting

### Pods Not Starting

Check pod status and events:
```bash
kubectl describe pod -l app=drupal-mysql
kubectl describe pod -l app=drupal
```

### PVC Not Binding

Check PV and PVC status:
```bash
kubectl describe pv drupal-mysql-pv
kubectl describe pvc drupal-mysql-pvc
```

Ensure `/drupal-mysql-data` directory exists on the worker node:
```bash
# On the worker node
sudo mkdir -p /drupal-mysql-data
sudo chmod 777 /drupal-mysql-data
```

### MySQL Connection Issues

Verify MySQL service is running:
```bash
kubectl get svc drupal-mysql-service
kubectl logs -l app=drupal-mysql
```

Test connection from Drupal pod:
```bash
kubectl exec -it <drupal-pod-name> -- bash
apt-get update && apt-get install -y mysql-client
mysql -h drupal-mysql-service -u drupal -p
# Enter password: drupalpass
```

### Cannot Access Drupal UI

Check the service and node port:
```bash
kubectl get svc drupal-service
```

Verify NodePort is accessible:
```bash
curl http://<node-ip>:30095
```

## Cleanup

To remove all resources:

```bash
# Delete all resources
kubectl delete -f drupal-k8s.yaml

# Optionally, clean up the data directory on worker node
# WARNING: This will delete all database data
sudo rm -rf /drupal-mysql-data/*
```

## Scaling

### Scale Drupal Deployment

```bash
# Scale Drupal to 3 replicas
kubectl scale deployment drupal --replicas=3

# Verify
kubectl get pods -l app=drupal
```

**Note**: MySQL should remain at 1 replica for this configuration since it uses a single PVC.

## Customization

### Change MySQL Version

Edit the deployment:
```yaml
image: mysql:8.0  # or any other version
```

### Change Drupal Version

Edit the deployment:
```yaml
image: drupal:9.5  # or any other version
```

### Increase Storage

Edit PV and PVC storage values:
```yaml
# Persistent Volume
storage: 10Gi

# Persistent Volume Claim
storage: 8Gi
```

## Security Recommendations

For production deployments:

1. **Change default passwords** in the secret
2. **Use external secret management** (e.g., Sealed Secrets, Vault)
3. **Enable TLS/SSL** using Ingress with cert-manager
4. **Implement network policies** to restrict pod-to-pod communication
5. **Use resource limits** on containers
6. **Regular backups** of persistent volume data
7. **Keep images updated** with security patches

## Support

For issues or questions:
- Check Kubernetes documentation: https://kubernetes.io/docs/
- Drupal documentation: https://www.drupal.org/docs
- MySQL documentation: https://dev.mysql.com/doc/

## License

This configuration is provided as-is for educational and deployment purposes.
