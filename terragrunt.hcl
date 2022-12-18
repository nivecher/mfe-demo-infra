locals {
  # Get environment specific configuration parameters
  config_path = "${get_parent_terragrunt_dir()}/config/${get_env("TG_CONFIG")}.yml"
  template_vars = {
    environment        = "${get_env("TG_CONFIG")}",
    region             = "${get_env("AWS_REGION")}",
    tf_state_dyn_table = "terraform-lock"
    namespace          = "example"
  }
  env_config = yamldecode(templatefile(local.config_path, local.template_vars))
}

inputs = merge(local.env_config)

# Reconfigure backend with terragrunt init
terraform {
  extra_arguments "init_args" {
    commands = ["init"]
    arguments = [
      "-backend=true",
      "-reconfigure"
    ]
  }
}

# Generate S3 remote state backend file
remote_state {
  backend      = "s3"
  disable_init = true
  generate = {
    path      = "backend-generated.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    "bucket" : "terraform-state-${local.env_config.region}-${get_env("AWS_ACCOUNT_ID")}"
    "key" : "${get_env("REPO")}/${local.env_config.environment}/terraform.tfstate"
    "region" : local.env_config.region
    "dynamodb_table" : local.env_config.tf_state_dyn_table
    "encrypt" : true
  }
}

# TODO maybe generate providers.tf file too, any advantage?
