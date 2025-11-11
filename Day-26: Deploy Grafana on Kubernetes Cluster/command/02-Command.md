# Delete the failed deployment if it exists
kubectl delete deployment grafana-deployment-nautilus 2>/dev/null

# Reapply the corrected configuration
kubectl apply -f grafana-deployment.yaml
kubectl get deployment grafana-deployment-nautilus
kubectl get pods -l app=grafana
kubectl get svc grafana-service-nautilus
