kubectl get crd gateways.gateway.networking.k8s.io &> /dev/null || { kubectl kustomize "github.com/kubernetes-sigs/gateway-api/config/crd?ref=v1.2.0" | kubectl apply -f -; }
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.24/samples/bookinfo/platform/kube/bookinfo.yaml
# 🚀 45 Days of Kubernetes – Complete Learning Journey

This repository documents my **45-day hands-on Kubernetes learning journey**, covering core concepts, workloads, networking, storage, configuration, troubleshooting, and real-world application deployments.

The goal of this challenge was to build **practical, production-oriented Kubernetes skills** by working daily on tasks, YAML manifests, and debugging scenarios.

---

## 📌 What This Repository Covers

* Kubernetes core objects (Pods, Deployments, ReplicaSets, Jobs, CronJobs)
* Configuration & management (Namespaces, Environment Variables, Secrets)
* Application lifecycle (Rolling updates, Rollbacks)
* Storage (Volumes, Persistent Volumes, Shared Volumes)
* Advanced patterns (Init Containers, Sidecar Containers)
* Troubleshooting real Kubernetes issues
* End-to-end application deployments

---

## 🗂️ Daily Progress Breakdown

### 🔰 Basics & Core Concepts

* **Day 01**: Deploy Pods in Kubernetes Cluster
* **Day 02**: Deploy Applications with Kubernetes Deployments
* **Day 03**: Setup Kubernetes Namespaces and Pods
* **Day 04**: Set Resource Limits in Kubernetes Pods

### 🔄 Deployment Strategies

* **Day 05**: Execute Rolling Updates in Kubernetes
* **Day 06**: Revert Deployment to Previous Version
* **Day 07**: Deploy ReplicaSet in Kubernetes Cluster

### ⏱️ Jobs & Scheduling

* **Day 08**: Schedule CronJobs in Kubernetes
* **Day 09**: Create Countdown Job in Kubernetes
* **Day 10**: Set Up Time Check Pod

### 📦 Controllers & Replication

* **Day 11**: Deploy Pods in Kubernetes Cluster
* **Day 12**: Deploy Applications with Kubernetes Deployments
* **Day 13**: Rolling Updates & Resource Limits
* **Day 14**: Update Deployment and Service
* **Day 15**: Rollback Kubernetes Deployments
* **Day 16**: High Availability Pods using ReplicationController

### 💾 Storage & Volumes

* **Day 17–18**: Resolve VolumeMount Issues
* **Day 19**: Kubernetes Shared Volumes
* **Day 33**: Persistent Volumes in Kubernetes

### 🔁 Advanced Pod Patterns

* **Day 20–21**: Kubernetes Sidecar Containers
* **Day 32**: Init Containers in Kubernetes

### 🌐 Web Servers & Applications

* **Day 22**: Deploy Nginx Web Server
* **Day 30**: Deploy Apache Web Server
* **Day 31**: Deploy LAMP Stack
* **Day 36**: Kubernetes LEMP Setup
* **Day 43**: Nginx and PHP-FPM Setup

### 🔐 Configuration & Security

* **Day 23**: Print Environment Variables
* **Day 34**: Manage Secrets in Kubernetes
* **Day 35**: Environment Variables in Kubernetes

### 🛠️ CI/CD, Monitoring & Tools

* **Day 25**: Deploy Jenkins on Kubernetes
* **Day 26**: Deploy Grafana on Kubernetes Cluster

### 🧪 Troubleshooting & Fixes

* **Day 27**: Fix LAMP Environment Issues
* **Day 37**: Kubernetes Troubleshooting
* **Day 39**: Fix Python App on Kubernetes

### 📱 Real-World Applications

* **Day 38**: Deploy Iron Gallery App
* **Day 40**: Deploy Redis on Kubernetes
* **Day 41**: Deploy MySQL on Kubernetes
* **Day 44**: Deploy Drupal App
* **Day 45**: Deploy Guest Book App 🎉

---

## 🧰 Tools & Technologies Used

* Kubernetes
* Docker
* kubectl
* YAML manifests
* Nginx, Apache, MySQL, Redis
* Jenkins, Grafana

---

## 🎯 Key Takeaways

* Strong understanding of Kubernetes architecture and workloads
* Hands-on experience with real-world deployment scenarios
* Improved troubleshooting and debugging skills
* Confidence in deploying production-like applications on Kubernetes

---

## 🏁 Conclusion

Completing this **45 Days of Kubernetes challenge** has significantly strengthened my Kubernetes fundamentals and practical experience. This repository serves as both a **learning log** and a **reference guide** for Kubernetes implementations.

📌 *Next Steps*: Advanced networking, Helm charts, Kubernetes security, and cloud-managed Kubernetes services.

---

⭐ If you find this repository useful, feel free to star it!

