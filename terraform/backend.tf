terraform {
  backend "s3" {
    bucket  = "prm-gp2gp-terraform-state"
    region  = "eu-west-2"
    encrypt = true
  }
}