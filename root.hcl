remote_state {
  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket       = "terraform-mikrotik-state-840471932663-eu-central-1-an"
    key          = "${replace(path_relative_to_include(), "infrastructure/", "")}/tfstate.json"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }
}