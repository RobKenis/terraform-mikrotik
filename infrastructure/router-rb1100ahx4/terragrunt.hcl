include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "provider" {
  path   = "./provider.hcl"
  expose = true
}

terraform {
  source = "../../modules/base"
}

inputs = {
  hostname = upper(split("-", basename(get_terragrunt_dir()))[1])
  timezone = "Europe/Brussels"
}