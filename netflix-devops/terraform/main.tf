provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "netflix_sg" {
  name = "netflix-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
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

chmod 666 /var/run/docker.sock

docker pull jenkins/jenkins:lts

docker run -d \
  --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts

sleep 60

docker exec -u root jenkins bash -c '
apt-get update &&
apt-get install -y git wget unzip docker.io &&

wget https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip &&

unzip terraform_1.6.6_linux_amd64.zip &&

mv terraform /usr/local/bin/ &&

chmod +x /usr/local/bin/terraform &&

chmod 666 /var/run/docker.sock
'

EOF
}

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

chmod 666 /var/run/docker.sock

EOF
}