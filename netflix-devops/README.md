# Netflix DevOps CI/CD Pipeline Project

## Project Overview

This project demonstrates an end-to-end DevOps CI/CD pipeline for deploying a Netflix clone application using AWS, Jenkins, Docker, Terraform, and Amazon ECR.

The pipeline automates:

* Infrastructure provisioning
* Docker image creation
* Container registry push
* EC2 deployment
* Continuous Integration and Continuous Deployment

---

## Technologies Used

* AWS EC2
* AWS ECR
* AWS CloudWatch
* Terraform
* Jenkins
* Docker
* GitHub
* Linux
* Shell Scripting

---

## Architecture

GitHub → Jenkins → Docker Build → Amazon ECR → EC2 Deployment

---

## Features

* Automated CI/CD pipeline
* Infrastructure as Code using Terraform
* Docker containerization
* Amazon ECR image storage
* Automatic deployment on EC2
* GitHub webhook integration
* CloudWatch monitoring
* Elastic IP configuration for stable deployment

---

## CI/CD Workflow

1. Developer pushes code to GitHub
2. GitHub webhook triggers Jenkins pipeline
3. Jenkins pulls latest source code
4. Docker image is built
5. Docker image pushed to Amazon ECR
6. Jenkins connects to EC2 instance
7. Latest image pulled from ECR
8. Existing container removed
9. New container deployed automatically

---

## Jenkins Pipeline Stages

* Checkout
* Terraform Init
* Build Docker Image
* Tag Docker Image
* Push Image To ECR
* Deploy Application

---

## Project Setup

### Clone Repository

```bash
git clone https://github.com/Harshita079/netflix-devops-production.git
```

### Terraform

```bash
terraform init
terraform apply
```

### Jenkins

Configure Jenkins pipeline with GitHub webhook integration.

### Docker

```bash
docker build -t netflix-app .
```

---

## Monitoring

AWS CloudWatch is used to monitor:

* EC2 metrics
* CPU utilization
* Network activity
* Instance health

---

## Author

Harshita Pawar

