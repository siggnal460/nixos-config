{
  imports = [ ./hardware-configuration.nix ];

  networking = {
    hostName = "x86-merkat-auth";
    domain = "gappyland.org";
  };

  sops.defaultSopsFile = ../../x86-merkat-auth/secrets.yaml;
}
