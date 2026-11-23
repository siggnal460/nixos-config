provider "sops" {}

# Decrypted directly into the provider block below; never written to state.
ephemeral "sops_file" "opnsense" {
  source_file = "${path.module}/../../secrets/OPNsense.internal/secrets.yaml"
}

provider "opnsense" {
  uri            = var.opnsense_uri
  api_key        = ephemeral.sops_file.opnsense.data["api_key"]
  api_secret     = ephemeral.sops_file.opnsense.data["api_secret"]
  allow_insecure = var.allow_insecure
}
