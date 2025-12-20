#!/bin/bash

echo "======================================"
echo "LAMP Stack Kubernetes Deployment"
echo "======================================"

# Step 1: Apply all Kubernetes resources
echo -e "\n[1/5] Applying Kubernetes resources..."
kubectl apply -f lamp-deployment.yaml

# Wait for deployment to be ready
echo -e "\n[2/5] Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=lamp-wp --timeout=120s

# Get the pod name
POD_NAME=$(kubectl get pods -l app=lamp-wp -o jsonpath='{.items[0].metadata.name}')
echo "Pod name: $POD_NAME"

# Step 2: Wait a bit for MySQL to initialize
echo -e "\n[3/5] Waiting for MySQL to initialize (30 seconds)..."
sleep 30

# Step 3: Prepare index.php with environment variables
echo -e "\n[4/5] Preparing and copying index.php..."

# Create a modified version of index.php that uses environment variables
cat > /tmp/index.php.modified << 'EOF'
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

# Copy the file to the httpd container
kubectl cp /tmp/index.php.modified $POD_NAME:/app/index.php -c httpd-php-container

echo -e "\n[5/5] Deployment complete!"
echo "======================================"
echo "Access the application at:"
echo "http://<node-ip>:30008/index.php"
echo "======================================"

# Show pod status
echo -e "\nPod Status:"
kubectl get pods -l app=lamp-wp

# Show services
echo -e "\nServices:"
kubectl get svc lamp-service mysql-service

# Test the connection
echo -e "\nTesting connection to MySQL from PHP container..."
kubectl exec -it $POD_NAME -c httpd-php-container -- php -r "echo 'PHP MySQL extension available: ' . (extension_loaded('mysqli') ? 'Yes' : 'No') . PHP_EOL;"
