# main.tf

provider "aws" {
  region = var.aws_region
}

# =========================
# SECURITY GROUP
# =========================

resource "aws_security_group" "netflix_sg" {
  name = "netflix-sg"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# =========================
# CLOUDWATCH
# =========================

resource "aws_cloudwatch_log_group" "netflix_logs" {
  name              = "/netflix/devops/logs"
  retention_in_days = 7
}

# =========================
# NETFLIX SERVER
# =========================

resource "aws_instance" "netflix_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [
    aws_security_group.netflix_sg.id
  ]

  tags = {
    Name = "Netflix-App-Server"
  }
}

# =========================
# JENKINS SERVER
# =========================

resource "aws_instance" "jenkins_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [
    aws_security_group.netflix_sg.id
  ]

  user_data = <<-EOF
#!/bin/bash

yum update -y

yum install -y java-17-amazon-corretto

yum install -y docker git wget unzip

systemctl start docker
systemctl enable docker

usermod -aG docker ec2-user

wget -O /etc/yum.repos.d/jenkins.repo \
https://pkg.jenkins.io/redhat-stable/jenkins.repo

rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

yum upgrade -y

yum install -y jenkins

systemctl enable jenkins
systemctl start jenkins

wget https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip

unzip terraform_1.6.6_linux_amd64.zip

mv terraform /usr/local/bin/

EOF

  tags = {
    Name = "Jenkins-Server"
  }
}