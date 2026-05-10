terraform {
  backend "s3" {
    bucket = "harshita-netflix-tfstate"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}