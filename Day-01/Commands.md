# Go to home directory
```
cd /home/thor
```
# Create YAML file
```
vi pod-httpd.yaml
```
# Apply pod configuration
```
kubectl apply -f pod-httpd.yaml
```
# Check pod status
```
kubectl get pods
```
# Verify labels
```
kubectl get pod pod-httpd --show-labels
```
