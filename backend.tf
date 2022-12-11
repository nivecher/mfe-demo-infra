terraform {
  backend "s3" {
    bucket  = "terraform-state-562427544284"         # TODO make configurable
    key     = "mfe-demo-infra/dev/terraform.tfstate" # TODO make configurable
    region  = "us-east-2"                            # TODO make configurable
    encrypt = true
  }
}
