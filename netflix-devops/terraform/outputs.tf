# outputs.tf
output "jenkins_public_ip" {
  description = "Jenkins Server Public IP"

  value = module.jenkins_ec2.public_ip
}

output "app_public_ip" {
  description = "Application Server Public IP"

  value = module.app_ec2.public_ip
}