{ config, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking = {
    hostName = "x86-legigo-jovian";
  };

  config.gappyland.jovian = true;
}
