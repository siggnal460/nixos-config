{ pkgs, lib, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  stylix = {
    base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
  };

  zramSwap.enable = true;

  networking = {
    hostName = "x86-atxtwr-workstation";
  };

  boot.tmp.tmpfsSize = "95%";

  services.ratbagd.enable = true;

  fileSystems."/mnt/nvme0n1" = {
    device = "/dev/disk/by-uuid/5b778bef-b3af-4710-9d44-6424b693dc29";
    fsType = "ext4";
  };

  environment = {
    systemPackages = with pkgs; [
      system76-keyboard-configurator
      piper
    ];
  };
}
