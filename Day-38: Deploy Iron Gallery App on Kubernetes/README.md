# Iron Gallery Application - Kubernetes Deployment

## Overview

This repository contains the Kubernetes configuration for deploying the Iron Gallery application with MariaDB database on a Kubernetes cluster. The Iron Gallery is a web-based image gallery application developed by the Nautilus DevOps team.

## Architecture

The deployment consists of:

- **Iron Gallery Frontend**: A web application running on nginx serving the gallery interface
- **Iron DB (MariaDB)**: A database backend for storing gallery metadata
- **Services**: ClusterIP service for database and NodePort service for external access

## Prerequisites

- Kubernetes cluster (v1.19+)
- `kubectl` configured to communicate with your cluster
- Sufficient cluster resources (minimum 100Mi memory and 50m CPU for frontend)

## Components

### 1. Namespace
- **Name**: `iron-namespace-datacenter`
- **Purpose**: Isolates all Iron Gallery resources

### 2. Iron Gallery Deployment
- **Name**: `iron-gallery-deployment-datacenter`
- **Image**: `kodekloud/irongallery:2.0`
- **Replicas**: 1
- **Resources**:
  - Memory Limit: 100Mi
  - CPU Limit: 50m
- **Volumes**:
  - `config`: Mounted at `/usr/share/nginx/html/data`
  - `images`: Mounted at `/usr/share/nginx/html/uploads`

### 3. Iron DB Deployment
- **Name**: `iron-db-deployment-datacenter`
- **Image**: `kodekloud/irondb:2.0`
- **Replicas**: 1
- **Database Configuration**:
  - Database Name: `database_apache`
  - User: `iron_user`
  - Root Password: `R00tP@ssw0rd#2024`
  - User Password: `Us3rP@ssw0rd#2024`

### 4. Services

#### Iron DB Service
- **Name**: `iron-db-service-datacenter`
- **Type**: ClusterIP
- **Port**: 3306

#### Iron Gallery Service
- **Name**: `iron-gallery-service-datacenter`
- **Type**: NodePort
- **Port**: 80
- **NodePort**: 32678

## Deployment Instructions

### Step 1: Clone or Download Configuration

Save the `iron-gallery-complete.yaml` file to your working directory.

### Step 2: Deploy to Kubernetes

```bash
# Apply the configuration
kubectl apply -f iron-gallery-complete.yaml
```

Expected output:
```
namespace/iron-namespace-datacenter created
deployment.apps/iron-gallery-deployment-datacenter created
deployment.apps/iron-db-deployment-datacenter created
service/iron-db-service-datacenter created
service/iron-gallery-service-datacenter created
```

### Step 3: Verify Deployment

```bash
# Check all resources in the namespace
kubectl get all -n iron-namespace-datacenter

# Check namespace
kubectl get namespace iron-namespace-datacenter

# Check deployments status
kubectl get deployments -n iron-namespace-datacenter

# Check pods status
kubectl get pods -n iron-namespace-datacenter

# Check services
kubectl get services -n iron-namespace-datacenter
```

### Step 4: Wait for Pods to be Ready

```bash
# Wait for Iron Gallery pod
kubectl wait --for=condition=ready pod -l run=iron-gallery -n iron-namespace-datacenter --timeout=120s

# Wait for Iron DB pod
kubectl wait --for=condition=ready pod -l db=mariadb -n iron-namespace-datacenter --timeout=120s
```

### Step 5: Access the Application

The Iron Gallery application will be accessible at:

```
http://<NODE_IP>:32678
```

Replace `<NODE_IP>` with any node's IP address in your cluster.

To get node IPs:
```bash
kubectl get nodes -o wide
```

## Verification Commands

### Check Pod Logs

```bash
# Iron Gallery logs
kubectl logs -n iron-namespace-datacenter -l run=iron-gallery

# Iron DB logs
kubectl logs -n iron-namespace-datacenter -l db=mariadb
```

### Describe Resources

```bash
# Describe Iron Gallery deployment
kubectl describe deployment iron-gallery-deployment-datacenter -n iron-namespace-datacenter

# Describe Iron DB deployment
kubectl describe deployment iron-db-deployment-datacenter -n iron-namespace-datacenter

# Describe services
kubectl describe service iron-gallery-service-datacenter -n iron-namespace-datacenter
kubectl describe service iron-db-service-datacenter -n iron-namespace-datacenter
```

### Check Resource Usage

```bash
# Check pod resource usage
kubectl top pods -n iron-namespace-datacenter
```

## Troubleshooting

### Pods Not Starting

1. Check pod status:
   ```bash
   kubectl get pods -n iron-namespace-datacenter
   ```

2. Check pod events:
   ```bash
   kubectl describe pod <pod-name> -n iron-namespace-datacenter
   ```

3. Check logs:
   ```bash
   kubectl logs <pod-name> -n iron-namespace-datacenter
   ```

### Cannot Access Application

1. Verify service is running:
   ```bash
   kubectl get svc iron-gallery-service-datacenter -n iron-namespace-datacenter
   ```

2. Check if NodePort is accessible:
   ```bash
   curl http://<NODE_IP>:32678
   ```

3. Verify firewall rules allow traffic on port 32678

### Database Connection Issues

1. Check if database pod is running:
   ```bash
   kubectl get pods -n iron-namespace-datacenter -l db=mariadb
   ```

2. Verify database service:
   ```bash
   kubectl get svc iron-db-service-datacenter -n iron-namespace-datacenter
   ```

3. Test database connectivity from gallery pod:
   ```bash
   kubectl exec -it <iron-gallery-pod> -n iron-namespace-datacenter -- nc -zv iron-db-service-datacenter 3306
   ```

## Cleanup

To remove all Iron Gallery resources:

```bash
# Delete all resources
kubectl delete -f iron-gallery-complete.yaml

# Or delete namespace (which removes everything inside)
kubectl delete namespace iron-namespace-datacenter
```

## Configuration Details

### Environment Variables (Database)

| Variable | Value | Description |
|----------|-------|-------------|
| MYSQL_DATABASE | database_apache | Name of the database |
| MYSQL_USER | iron_user | Non-root database user |
| MYSQL_PASSWORD | Us3rP@ssw0rd#2024 | Password for iron_user |
| MYSQL_ROOT_PASSWORD | R00tP@ssw0rd#2024 | Root password for database |

### Volume Mounts

#### Iron Gallery Container
| Mount Path | Volume Type | Purpose |
|------------|-------------|---------|
| /usr/share/nginx/html/data | emptyDir | Configuration data |
| /usr/share/nginx/html/uploads | emptyDir | Uploaded images |

#### Iron DB Container
| Mount Path | Volume Type | Purpose |
|------------|-------------|---------|
| /var/lib/mysql | emptyDir | Database storage |

## Notes

1. **Initial Setup**: The application will show an installation page on first access. Database connection configuration is not required at this stage.

2. **Persistent Storage**: Currently using `emptyDir` volumes. Data will be lost if pods are restarted. For production, consider using PersistentVolumes.

3. **Security**: Update the database passwords in a production environment and consider using Kubernetes Secrets.

4. **Resource Limits**: The frontend has resource limits set. Monitor and adjust based on actual usage.

5. **High Availability**: Currently configured with 1 replica. Increase replicas for better availability in production.

## Support

For issues or questions regarding the deployment, contact the Nautilus DevOps team.

## Version

- Iron Gallery Image: `kodekloud/irongallery:2.0`
- Iron DB Image: `kodekloud/irondb:2.0`
- Configuration Version: 1.0
