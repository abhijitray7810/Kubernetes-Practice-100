# Step 1: Create a Deployment for Grafana
kubectl create deployment grafana-deployment-nautilus --image=grafana/grafana

# Step 2: Expose the Deployment using a NodePort Service
kubectl expose deployment grafana-deployment-nautilus \
  --type=NodePort \
  --port=3000 \
  --target-port=3000 \
  --name=grafana-service-nautilus \
  --node-port=32000

# Step 3: Verify Deployment and Service
kubectl get deployments
kubectl get pods
kubectl get svc

# Step 4: Once Pod is running, access Grafana via:
# http://<NodeIP>:32000
# (Use any node IP of your Kubernetes cluster)
