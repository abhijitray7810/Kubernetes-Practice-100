#### 🚀 Task: Create a Pod with Resource Limits

The Nautilus DevOps team needs to create a pod named **`httpd-pod`** with defined CPU and memory requests and limits to prevent resource overuse.

---

### **Steps & Commands**

1. **Create the pod definition file**

   ```bash
   vi httpd-pod.yml
   ```

2. **Add the following YAML configuration**

   ```yaml
   apiVersion: v1
   kind: Pod
   metadata:
     name: httpd-pod
   spec:
     containers:
       - name: httpd-container
         image: httpd:latest
         resources:
           requests:
             memory: "15Mi"
             cpu: "100m"
           limits:
             memory: "20Mi"
             cpu: "100m"
   ```

3. **Apply the pod configuration**

   ```bash
   kubectl apply -f httpd-pod.yml
   ```

4. **Verify the pod is created**

   ```bash
   kubectl get pods
   ```

5. **Describe the pod to confirm resource settings**

   ```bash
   kubectl describe pod httpd-pod
   ```

---

✅ **Result:**
A pod named `httpd-pod` is created using the `httpd:latest` image, with:

* **Requests:** 15Mi memory, 100m CPU
* **Limits:** 20Mi memory, 100m CPU

---

Would you like me to include this same format (with emoji headings and explanations) in your GitHub project folder version too?
