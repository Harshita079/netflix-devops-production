# terraform/main.tf

resource "aws_security_group" "jenkins_sg" {
  name = "jenkins-sg"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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

resource "aws_instance" "jenkins" {
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

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

# Create Jenkins Docker volume
docker volume create jenkins_home

# Run Jenkins container with Docker socket
docker run -d \
  --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts

# Wait for Jenkins startup
sleep 90

# Install Terraform + Docker CLI inside Jenkins container
docker exec -u root jenkins bash -c '
apt-get update && \
apt-get install -y wget unzip docker.io && \

wget https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip && \

unzip terraform_1.6.6_linux_amd64.zip && \

mv terraform /usr/local/bin/ && \

chmod +x /usr/local/bin/terraform && \

terraform --version
'
EOF

  tags = {
    Name = "Jenkins-Server"
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "jenkins-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    InstanceId = aws_instance.jenkins.id
  }
}