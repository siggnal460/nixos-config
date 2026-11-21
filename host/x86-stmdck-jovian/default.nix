{
  imports = [
    ./hardware-configuration.nix
    ../../user/aaron
    ../../user/aaron/console
  ];

  networking = {
    hostName = "x86-stmdck-jovian";
  };

  jovian.devices.steamdeck.enable = true;
}
