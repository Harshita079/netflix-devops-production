# Netflix DevOps Production Project

## Project Overview

This project demonstrates a simplified production-style DevOps pipeline using:

- AWS EC2
- Terraform
- Jenkins
- Docker
- CloudWatch
- S3 Backend
- GitHub Webhooks

The project automatically provisions infrastructure, validates Terraform configuration, builds Docker images, and deploys a Netflix clone application.

---

# Architecture

GitHub → Jenkins Pipeline → Terraform → AWS EC2 → Docker → Netflix App

---

# Technologies Used

- AWS EC2
- Terraform
- Jenkins
- Docker
- GitHub
- CloudWatch
- S3 Backend
- HTML
- CSS
- JavaScript
- Nginx

---

# Project Structure

```text
netflix-devops-production/
│
├── app/
│   ├── index.html
│   ├── style.css
│   └── script.js
│
├── docker/
│   └── Dockerfile
│
├── jenkins/
│   └── Jenkinsfile
│
├── terraform/
│   ├── backend.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── provider.tf
│   ├── terraform.tfvars
│   ├── variables.tf
│   └── versions.tf
│
├── scripts/
│   └── deploy.sh
│
├── README.md
└── .gitignore

## Commands

### Terraform

terraform init

terraform plan

terraform apply

terraform destroy

### Jenkins

Access Jenkins:

http://<JENKINS_PUBLIC_IP>:8080