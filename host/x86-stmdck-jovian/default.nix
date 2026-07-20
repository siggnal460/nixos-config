{
  imports = [ ./hardware-configuration.nix ];

  networking = {
    hostName = "x86-stmdck-jovian";
  };

  jovian.devices.steamdeck.enable = true;
}
