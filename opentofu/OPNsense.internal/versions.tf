terraform {
  required_version = ">= 1.10.0" # ephemeral resources

  required_providers {
    opnsense = {
      source  = "browningluke/opnsense"
      version = "~> 0.26"
    }
    sops = {
      source  = "carlpett/sops"
      version = "~> 1.2"
    }
  }
}
