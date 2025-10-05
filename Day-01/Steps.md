1. Connect to the jump_host using the terminal.

2. Move to your home directory:
   cd /home/thor

3. Create a YAML file for the pod:
   vi pod-httpd.yaml

4. Add the following YAML configuration:

   apiVersion: v1
   kind: Pod
   metadata:
     name: pod-httpd
     labels:
       app: httpd_app
   spec:
     containers:
       - name: httpd-container
         image: httpd:latest
         ports:
           - containerPort: 80

5. Save and exit the file (:wq in vi).

6. Apply the configuration to create the pod:
   kubectl apply -f pod-httpd.yaml

7. Verify the pod creation:
   kubectl get pods

8. Confirm labels:
   kubectl get pod pod-httpd --show-labels

