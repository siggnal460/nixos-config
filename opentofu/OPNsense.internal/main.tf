locals {
  lan_gateway    = cidrhost(var.lan_subnet, 1)
  lan_pool_start = cidrhost(var.lan_subnet, 100)
  lan_pool_end   = cidrhost(var.lan_subnet, 200)
}

# Alias for the LAN network, reusable in firewall rules below.
resource "opnsense_firewall_alias" "lan_net" {
  name        = "lan_net"
  type        = "network"
  content     = [var.lan_subnet]
  description = "LAN network"
}

# DHCP for LAN clients.
resource "opnsense_kea_dhcpv4_subnet" "lan" {
  subnet      = var.lan_subnet
  routers     = [local.lan_gateway]
  dns_servers = [local.lan_gateway]
  pools       = ["${local.lan_pool_start}-${local.lan_pool_end}"]
  description = "LAN DHCP pool"
}

# Allow LAN clients to reach anything (the usual default-allow-outbound rule).
resource "opnsense_firewall_filter" "allow_lan_out" {
  description = "Allow LAN to any"
  sequence    = 1

  interface = {
    interface = ["lan"]
  }

  filter = {
    quick     = true
    action    = "pass"
    direction = "in"
    protocol  = "any"

    source = {
      net = opnsense_firewall_alias.lan_net.name
    }

    destination = {
      net = "any"
    }
  }
}

# Lets LAN clients reach the router itself at OPNsense.internal.
resource "opnsense_unbound_host_override" "router" {
  hostname    = "OPNsense"
  domain      = "internal"
  type        = "A"
  server      = local.lan_gateway
  description = "Router LAN IP"
}
