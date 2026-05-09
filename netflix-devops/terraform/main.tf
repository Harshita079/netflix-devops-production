# main.tf

module "vpc" {
  source = "./modules/vpc"

  project_name       = var.project_name
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
}

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

              yum update -y

              # Install Docker and Git
              yum install -y docker git

              # Start Docker
              systemctl start docker
              systemctl enable docker

              # Add ec2-user to docker group
              usermod -aG docker ec2-user

              # Create Jenkins Volume
              docker volume create jenkins_home

              # Run Jenkins Container
              docker run -d \
                --name jenkins \
                -p 8080:8080 \
                -p 50000:50000 \
                -v jenkins_home:/var/jenkins_home \
                jenkins/jenkins:lts

              # Wait for Jenkins to fully start
              sleep 40

              # Install Terraform + AWS CLI + Docker CLI inside Jenkins container
              docker exec -u root jenkins bash -c '
              apt-get update && \
              apt-get install -y wget unzip curl git docker.io && \

              wget https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip && \
              unzip terraform_1.6.6_linux_amd64.zip && \
              mv terraform /usr/local/bin/ && \
              rm terraform_1.6.6_linux_amd64.zip && \

              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
              unzip awscliv2.zip && \
              ./aws/install
              '
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

              yum update -y

              # Install Docker and Git
              yum install -y docker git

              # Start Docker
              systemctl start docker
              systemctl enable docker

              # Add ec2-user to docker group
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