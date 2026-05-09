# main.tf

provider "aws" {
  region = var.aws_region
}

# =========================================
# SECURITY GROUP
# =========================================

resource "aws_security_group" "netflix_sg" {
  name        = "netflix-sg"
  description = "Security Group for Netflix DevOps Project"

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
    description = "Application"
    from_port   = 3000
    to_port     = 3000
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

  tags = {
    Name = "Netflix-SG"
  }
}

# =========================================
# JENKINS SERVER
# =========================================

resource "aws_instance" "jenkins" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.netflix_sg.id]

  tags = {
    Name = "Jenkins-Server"
  }

  user_data = <<-EOF
              #!/bin/bash

              yum update -y

              yum install -y docker git unzip wget

              systemctl start docker
              systemctl enable docker

              usermod -aG docker ec2-user

              docker pull jenkins/jenkins:lts

              docker run -d \
                --name jenkins \
                -p 8080:8080 \
                -p 50000:50000 \
                -v jenkins_home:/var/jenkins_home \
                -v /var/run/docker.sock:/var/run/docker.sock \
                jenkins/jenkins:lts

              # WAIT FOR JENKINS TO FULLY START
              sleep 120

              # INSTALL TERRAFORM INSIDE JENKINS CONTAINER
              docker exec -u root jenkins bash -c '
              apt-get update &&
              apt-get install -y wget unzip &&
              wget https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip &&
              unzip terraform_1.6.6_linux_amd64.zip &&
              mv terraform /usr/local/bin/ &&
              chmod +x /usr/local/bin/terraform
              '

              EOF
}

# =========================================
# APPLICATION SERVER
# =========================================

resource "aws_instance" "app" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.netflix_sg.id]

  tags = {
    Name = "Netflix-App"
  }

  user_data = <<-EOF
              #!/bin/bash

              yum update -y

              yum install -y docker git

              systemctl start docker
              systemctl enable docker

              usermod -aG docker ec2-user
              EOF
}

# =========================================
# CLOUDWATCH LOG GROUP
# =========================================

resource "aws_cloudwatch_log_group" "netflix_logs" {
  name              = "/netflix/devops/logs"
  retention_in_days = 7
}

# =========================================
# OUTPUTS
# =========================================

output "jenkins_ip" {
  value = aws_instance.jenkins.public_ip
}

output "app_ip" {
  value = aws_instance.app.public_ip
}