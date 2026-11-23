variable "opnsense_uri" {
  description = "Base URL of the OPNsense web UI/API, e.g. https://10.10.10.1"
  type        = string
}

variable "allow_insecure" {
  description = "Skip TLS certificate verification (only needed for a self-signed cert)"
  type        = bool
  default     = false
}

variable "lan_subnet" {
  description = "LAN network in CIDR form, e.g. 10.10.10.0/24"
  type        = string
  default     = "10.10.10.0/24"
}
