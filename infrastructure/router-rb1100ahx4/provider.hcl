locals {
  mikrotik_hostname = "172.16.0.1"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    provider "routeros" {
      hosturl  = "http://${local.mikrotik_hostname}"
      username = "${get_env("MIKROTIK_USERNAME")}"
      password = "${get_env("MIKROTIK_PASSWORD")}"
      insecure = true
    }
  EOF
}