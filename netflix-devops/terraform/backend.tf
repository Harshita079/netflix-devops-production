# backend.tf

terraform {
  backend "s3" {
    bucket = "harshita-netflix-tfstate-2026 "
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}