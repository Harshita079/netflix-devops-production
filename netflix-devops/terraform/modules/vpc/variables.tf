# variables.tf

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
}

variable "public_subnet_cidr" {
  description = "Public Subnet CIDR"
  type        = string
}

variable "availability_zone" {
  description = "Availability Zone"
  type        = string
}
