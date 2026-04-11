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
