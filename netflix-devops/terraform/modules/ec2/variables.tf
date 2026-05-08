# variables.tf

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "instance_name" {
  description = "EC2 Instance Name"
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
}

variable "ami_id" {
  description = "AMI ID"
  type        = string
}

variable "key_name" {
  description = "AWS Key Pair Name"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID"
  type        = string
}

variable "user_data" {
  description = "User Data Script"
  type        = string
}