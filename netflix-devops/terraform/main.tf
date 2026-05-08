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

              yum install docker git -y

              systemctl start docker
              systemctl enable docker

              docker run -d \
                -p 8080:8080 \
                -p 50000:50000 \
                --name jenkins \
                jenkins/jenkins:lts
              EOF
}

module "app_ec2" {
  source = "./modules/ec2"

  project_name      = var.project_name

  instance_name     = "app-server"

  instance_type     = var.instance_type

  ami_id            = "ami-0eb38b817b93460ac"

  key_name          = var.key_name

  subnet_id         = module.vpc.public_subnet_id

  security_group_id = module.security_group.security_group_id

  user_data = <<-EOF
              #!/bin/bash

              yum update -y

              yum install docker git -y

              systemctl start docker
              systemctl enable docker
              EOF
}

module "monitoring" {
  source = "./modules/monitoring"

  project_name = var.project_name

  instance_id  = module.app_ec2.instance_id
}