{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../user/aaron
    ../../user/aaron/console
    ../../user/aaron/host/x86-legigo-jovian
  ];

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
