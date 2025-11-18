# These project 02-mocroservice-deployment is part of the cloud protfolio project showcase 

# Practical Usage Guide

Below is a practical usage section that can be appended to your existing `README.md` for the repository **02-eks-microservices-deployment**.

---

## 🚀 ## Hands-On Guide: Deploying Microservices on AWS EKS

This section provides hands-on steps to help DevOps engineers deploy, manage, and validate the EKS Microservices Infrastructure using Terraform, Kubernetes, GitLab CI/CD, and AWS services.

---

## 1. **Clone the Repository**

```bash
git clone https://github.com/fred4impact/02-eks-microservices-deployment.git
cd 02-eks-microservices-deployment
```

---

## 2. **Configure Terraform Backend (Recommended)**

Edit `terraform/backend.tf` or create one if missing:

```hcl
terraform {
  backend "s3" {
    bucket         = "your-tfstate-bucket"
    key            = "eks-microservices/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}
```
Create a dev.tfvars file for your own project variables

Apply backend creation separately before first deploy.

---

## 3. **Initialize Terraform**

```bash
cd terraform
terraform init
```

This downloads providers and configures your S3 backend.

---

## 4. **Preview Infrastructure Changes**

```bash
terraform plan
```

Validate that:

* VPC
* Subnets
* EKS cluster
* Node groups
* IAM roles
  will be created.

---

## 5. **Deploy Full AWS Infrastructure**

```bash
terraform apply -auto-approve
```

This provisions:

* VPC
* Internet Gateway / NAT Gateway
* Public & Private Subnets
* EKS Cluster
* Node Groups

Once complete, Terraform outputs the EKS cluster name and kubeconfig information.

---

## 6. **Update Local Kubeconfig**

```bash
aws eks update-kubeconfig --region us-east-1 --name <cluster-name>
```

Verify access:

```bash
kubectl get nodes
```

---

## 7. **Deploy Microservices**

Depending on the repo structure, apply:

```bash
kubectl apply -f k8s-manifests/
```

Or if Helm charts are used:

```bash
helm install service-a helm-charts/service-a
```

Validate deployment:

```bash
kubectl get pods -A
```

---

## 8. **Configure Ingress / ALB Controller**

If ingress is configured:

```bash
kubectl apply -f ingress/
```

AWS ALB will automatically be created in the public subnet.
Retrieve the ALB DNS:

```bash
kubectl get ingress
```

Access the app via the ALB URL.

---

## 9. **GitLab CI/CD Automation**

### Configure Variables in GitLab:

* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `AWS_DEFAULT_REGION`
* `ECR_REPOSITORY`
* `KUBE_CONFIG`

### Pipeline Flow:

1. Terraform init → plan → apply
2. Build Docker images
3. Push to ECR
4. Deploy to EKS using kubectl or Helm

Re-run pipeline on each commit to automate deployments.

---

## 10. **Monitoring & Logging**

If using Prometheus + Grafana:

```bash
kubectl apply -f monitoring/
```

Grafana port-forward:

```bash
kubectl port-forward svc/grafana 3000:3000 -n monitoring
```

Access via:

```
http://localhost:3000
```

---

## 11. **Destroy All Infrastructure**

Use this only for cleanup:

```bash
terraform destroy -auto-approve
```

Ensure no important workloads are running.

---

## ✔ Summary

This practical guide walks through cloning, provisioning, deploying microservices, configuring CI/CD, and validating your full AWS EKS microservices setup. It is designed for DevOps engineers who want a clean, reproducible workflow for cloud-native microservice deployment on Kubernetes.

If you want this merged directly into the repo's existing README or want a polished GitHub-ready formatting, let me know!
