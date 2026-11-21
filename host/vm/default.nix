{ lib, ... }:
let
  hostname = "vm";
in
{
  imports = [
    ./hardware-configuration.nix
    ../../user/aaron
    ../../user/aaron/workstation
    ../../user/aaron/host/vm
  ];

  networking = {
    hostName = hostname;
  };

  boot.loader = {
    systemd-boot.enable = lib.mkForce false;
    grub.enable = lib.mkForce true;
    grub.device = lib.mkForce "/dev/vda";
    grub.useOSProber = true;
  };
}
