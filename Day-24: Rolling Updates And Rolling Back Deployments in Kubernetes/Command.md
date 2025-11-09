## **command.md**

```bash
# Step 1: Create the namespace
kubectl create namespace xfusion

# Step 2: Create the deployment under the new namespace with 2 replicas
kubectl create deployment httpd-deploy \
  --image=httpd:2.4.25 \
  --replicas=2 \
  -n xfusion

# Step 3: Patch the deployment to set the RollingUpdate strategy
kubectl patch deployment httpd-deploy -n xfusion \
  -p '{
    "spec": {
      "strategy": {
        "type": "RollingUpdate",
        "rollingUpdate": {
          "maxSurge": 1,
          "maxUnavailable": 2
        }
      }
    }
  }'

# Step 4: Create a NodePort service manually (since kubectl expose doesn’t support --node-port)
kubectl create service nodeport httpd-service \
  --tcp=80:80 \
  -n xfusion \
  --node-port=30008

# Step 5: Patch the deployment to include containerPort for service mapping
kubectl patch deployment httpd-deploy -n xfusion \
  -p '{"spec":{"template":{"spec":{"containers":[{"name":"httpd","ports":[{"containerPort":80}]}]}}}}'

# Step 6: Patch the service selector to match the deployment label
kubectl patch service httpd-service -n xfusion \
  -p '{"spec":{"selector":{"app":"httpd-deploy"}}}'

# Step 7: Verify deployment, pods, and service
kubectl get all -n xfusion
kubectl get endpoints httpd-service -n xfusion

# Step 8: Perform rolling update to upgrade image version
kubectl set image deployment/httpd-deploy httpd=httpd:2.4.43 -n xfusion

# Step 9: Check rollout status
kubectl rollout status deployment/httpd-deploy -n xfusion

# Step 10: Verify new version
kubectl describe deployment httpd-deploy -n xfusion | grep Image

# Step 11: Undo the recent update (rollback to previous version)
kubectl rollout undo deployment/httpd-deploy -n xfusion

# Step 12: Verify rollback and service access
kubectl rollout status deployment/httpd-deploy -n xfusion
kubectl describe deployment httpd-deploy -n xfusion | grep Image
kubectl get endpoints httpd-service -n xfusion

# Step 13: Test from jump host
curl http://172.17.0.2:30008
```

---

✅ **Result After Execution**

* Namespace: `xfusion`
* Deployment: `httpd-deploy`

  * Image rolled back to `httpd:2.4.25`
  * Replicas: `2`
  * Strategy: `RollingUpdate (maxSurge=1, maxUnavailable=2)`
* Service: `httpd-service` (NodePort: `30008`)
* Endpoints connected to both pods
* Accessible via: `http://172.17.0.2:30008`

---

Would you like me to generate this as a **downloadable `command.md` file** so you can upload it directly (for KodeKloud or any review system)?
