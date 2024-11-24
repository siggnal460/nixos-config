# Bluetooth compatability
{ pkgs, ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    package = pkgs.bluez5-experimental;
    settings.Policy.AutoEnable = "true";
    settings.General.Enable = "Source,Sink,Media,Socket";
  };

  environment.systemPackages = with pkgs; [
    bluez5-experimental
    bluez-tools
    bluez-alsa
    bluetuith # can transfer files via OBEX
  ];
}
