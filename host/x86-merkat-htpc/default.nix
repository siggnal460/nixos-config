{
  imports = [ ./hardware-configuration.nix ];

  swapDevices = [
    {
      device = "/swapfile";
      size = 128 * 1024;
    }
  ];

  networking = {
    hostName = "x86-merkat-htpc";
  };
}
