{ config, ... }:
{
  # Internal certificate authority for LAN-only TLS. Issues certs via ACME
  # (HTTP-01) so no public DNS or provider dependency is needed.
  #
  # Bootstrap (one-time, done by the user, not Nix):
  #   1. Run `step ca init` to generate the root/intermediate CA.
  #   2. Keep the root key offline; copy root_ca.crt and intermediate_ca.crt
  #      (public) into this repo (see files/ and ../../../shared/pki/).
  #   3. Add step-ca/intermediate_ca_key and step-ca/intermediate_password
  #      to secrets/x86-merkat-auth/secrets.yaml via `sops`.
  services.step-ca = {
    enable = true;
    address = "0.0.0.0";
    port = 8443;
    openFirewall = true;
    intermediatePasswordFile = config.sops.secrets."step-ca/intermediate_password".path;
    settings = {
      root = ../../../shared/pki/root_ca.crt;
      crt = ./files/intermediate_ca.crt;
      key = "/var/lib/step-ca/secrets/intermediate_ca_key";
      dnsNames = [
        "x86-merkat-auth"
        "x86-merkat-auth.gappyland.org"
      ];
      db = {
        type = "badgerv2";
        dataSource = "/var/lib/step-ca/db";
      };
      authority.provisioners = [
        {
          type = "ACME";
          name = "acme";
        }
      ];
    };
  };

  sops.secrets = {
    "step-ca/intermediate_password" = { };
    "step-ca/intermediate_ca_key" = {
      path = "/var/lib/step-ca/secrets/intermediate_ca_key";
    };
  };
}
