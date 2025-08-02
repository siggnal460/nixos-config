{ ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking = {
    hostName = "x86-legigo-jovian";
  };

  jovian.hardware = {
    has.amd.gpu = true;
    amd.gpu.enableBacklightControl = true;
    steamdeck.enable = false;
  };
}
