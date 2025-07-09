# 🌐 AWS Disaster Management Project

This project demonstrates a **highly available, fault-tolerant static web application** hosted on AWS, using **Terraform** to provision infrastructure as code.

---

## 🎯 Objective

To build a resilient infrastructure that ensures:
- Automated **failover routing** between EC2 instances
- **Health checks** for monitoring instance status
- Hosting a **static website** from **EC2** and **S3**
- Managing **DNS with Route 53**
- Using **Amazon RDS** as a secure relational database backend

---

## 🛠️ Technologies Used

- Terraform
- AWS EC2 (Primary & Secondary Instances)
- AWS Route 53
- Amazon RDS (MySQL)
- Amazon S3 (Static assets)
- Git & GitHub

---

## 🧱 Architecture

![Architecture Diagram](architecture.png)

---

## 📁 Directory Structure

Disaster-Management/
├── main.tf
├── vpc.tf
├── ec2.tf
├── alb.tf
├── route53.tf
├── rds.tf
├── variables.tf
├── outputs.tf
├── index.html
├── Styles.css
├── .gitignore

yaml
Copy
Edit

---

## ☁️ Features

- ✅ EC2 with Apache hosting static website
- ✅ S3 for serving static content to EC2
- ✅ Route 53 DNS Failover using health checks
- ✅ RDS MySQL DB for storing backend data
- ✅ Infrastructure fully managed via Terraform

---

## 🌐 Domain

Website hosted at:  
🔗 **[https://dineshprojectsmine.shop](https://dineshprojectsmine.shop)**

---

## 🚀 Deployment Guide

### 1️⃣ Initialize Terraform
```bash
terraform init
2️⃣ Validate and Plan
bash
Copy
Edit
terraform validate
terraform plan
3️⃣ Apply Infrastructure
bash
Copy
Edit
terraform apply
4️⃣ Update DNS
via Terraform, point your Route 53 records to:

EC2 Primary (A Record + Health Check)

EC2 Secondary (Failover A Record)

🔒 .gitignore Includes
bash
Copy
Edit
# Terraform
.terraform/
*.tfstate
*.tfstate.backup

# AWS credentials
*.pem

# System files
.DS_Store

# IDE
.vscode/
.idea/
__MACOSX/
📚 Future Scope
Add CI/CD (GitHub Actions)

Use CloudFront CDN with S3

Enable RDS backups and encryption

Add CloudWatch alarms and dashboards

👨‍💻 Author
Dinesh Kumar Kasi
GitHub: @dineshkumarkasi



