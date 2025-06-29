{
  imports = [ ./hardware-configuration.nix ];

  networking = {
    hostName = "x86-merkat-monitoring";
    domain = "gappyland.org";
  };

  sops.defaultSopsFile = ../../secrets/x86-merkat-auth/secrets.yaml;
}
