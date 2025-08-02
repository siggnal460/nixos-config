{ ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking = {
    hostName = "x86-legigo-jovian";
  };

  jovian = {
    devices.steamdeck.enable = false;
    hardware = {
      has.amd.gpu = true;
      amd.gpu.enableBacklightControl = true;
    };
  };
}
