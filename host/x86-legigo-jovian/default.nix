{ ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking = {
    hostName = "x86-legigo-jovian";
  };

  gappyland.jovian = true;
}
