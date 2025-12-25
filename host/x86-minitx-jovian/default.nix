{ pkgs, config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../system/shared/plymouth-quiet.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = with config.boot.kernelPackages; [ r8125 ];
    kernelParams = [
      "video=HDMI-A-2:3840x2160@120"
    ];
  };

  networking = {
    hostName = "x86-minitx-jovian";
  };

  jovian = {
    devices.steamdeck.enable = false;
    hardware = {
      has.amd.gpu = true;
      amd.gpu.enableBacklightControl = false;
    };
  };
}
