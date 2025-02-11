{ pkgs, ... }:
{
  imports = [
    ../../shared/remotely-managed.nix
  ];

  networking.wireless.enable = false;

  services = {
    clamav = {
      daemon.enable = true;
      scanner.enable = true;
      updater.enable = true;
      fangfrisch.enable = true;
    };
  };

  hardware.bluetooth = {
    enable = false;
    powerOnBoot = false;
  };

  environment.systemPackages = [
    pkgs.waypipe
  ];
}
