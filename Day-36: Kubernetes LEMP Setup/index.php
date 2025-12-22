# Find the nginx-php-container pod
POD_NAME=$(kubectl get pods -l app=lemp-wp -o jsonpath='{.items[0].metadata.name}')

# Copy the index.php file from jump_host to the pod
kubectl cp /tmp/index.php $POD_NAME:/app/index.php -c nginx-php-container

# Get into the pod to modify the file
kubectl exec -it $POD_NAME -c nginx-php-container -- sh
# Backup original file
cp /app/index.php /app/index.php.backup

# Create a new index.php with environment variables
cat > /app/index.php << 'EOF'
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
EOF
