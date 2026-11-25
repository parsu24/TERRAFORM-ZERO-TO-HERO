terraform {
  backend "s3" {
    bucket       = "parsu24-devops-terraform"
    region       = "us-west-2"
    key          = "prashant/terraform.tfstate"
    use_lockfile = true
  }
}
