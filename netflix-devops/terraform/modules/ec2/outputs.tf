# outputs.tf

output "instance_id" {
  description = "EC2 Instance ID"

  value = aws_instance.main.id
}

output "public_ip" {
  description = "Elastic Public IP"

  value = aws_eip.main.public_ip
}