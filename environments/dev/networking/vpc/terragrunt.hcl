terraform {
  source = "git::git@github.com:tabetaika/infrastructure-modules.git//modules/vpc?ref=v1.0.0"
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = "eu-west-1"
}
EOF
}

include "root" {
  path = find_in_parent_folders()
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "tabetaika-tfstate"

    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
  }
}

inputs = {
  tf_path = "${path_relative_to_include()}"
}
