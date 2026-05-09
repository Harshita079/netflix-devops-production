# =========================
# VPC
# =========================

module "vpc" {
  source = "./modules/vpc"

  project_name       = var.project_name
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
}

# =========================
# Security Group
# =========================

module "security_group" {
  source = "./modules/security-group"

  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
}

# =========================
# Jenkins Server
# =========================

module "jenkins_ec2" {
  source = "./modules/ec2"

  project_name      = var.project_name
  instance_name     = "jenkins-server"

  instance_type     = var.instance_type

  ami_id            = "ami-0c02fb55956c7d316"

  key_name          = var.key_name

  subnet_id         = module.vpc.public_subnet_id

  security_group_id = module.security_group.security_group_id

  user_data = <<-EOF
#!/bin/bash

# Update packages
yum update -y

# Install Docker and Git
yum install -y docker git

# Start Docker
systemctl start docker
systemctl enable docker

# Docker permissions
usermod -aG docker ec2-user

# Create Jenkins volume
docker volume create jenkins_home

# Run Jenkins container
docker run -d \
  --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts

# Wait for Jenkins startup
sleep 120

# Install Terraform inside Jenkins container
docker exec -u root jenkins bash -c "
apt-get update &&
apt-get install -y wget unzip curl git docker.io &&

wget https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip &&

unzip terraform_1.6.6_linux_amd64.zip &&

mv terraform /usr/local/bin/ &&

chmod +x /usr/local/bin/terraform &&

terraform --version
"
EOF
}

# =========================
# Application Server
# =========================

module "app_ec2" {
  source = "./modules/ec2"

  project_name      = var.project_name

  instance_name     = "app-server"

  instance_type     = var.instance_type

  ami_id            = "ami-0c02fb55956c7d316"

  key_name          = var.key_name

  subnet_id         = module.vpc.public_subnet_id

  security_group_id = module.security_group.security_group_id

  user_data = <<-EOF
#!/bin/bash

# Update packages
yum update -y

# Install Docker and Git
yum install -y docker git

# Start Docker
systemctl start docker
systemctl enable docker

# Docker permissions
usermod -aG docker ec2-user
EOF
}

# =========================
# Monitoring
# =========================

module "monitoring" {
  source = "./modules/monitoring"

  project_name = var.project_name

  instance_id  = module.app_ec2.instance_id
}