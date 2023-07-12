terraform {
  backend "s3" {
    bucket  = "m2c-terraform"
    key     = "ponyracer/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}
# Setup our aws provider
provider "aws" {
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  region     = var.AWS_REGION
}
