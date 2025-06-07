{ pkgs, lib, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  stylix = {
    base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
  };

  #boot.kernelPackages = pkgs.linuxPackages_latest;

  networking = {
    hostName = "x86-atxtwr-workstation";
  };

  boot.tmp.tmpfsSize = "95%";

  services.ratbagd.enable = true;

  systemd.tpm2.enable = false;

  environment = {
    systemPackages = with pkgs; [
      system76-keyboard-configurator
      piper
    ];
  };
}
