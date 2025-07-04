{
  imports = [ ./hardware-configuration.nix ];

  networking = {
    hostName = "x86-rasbpi-downloadclient";
    domain = "gappyland.org";
  };
}
