{
  imports = [ ./hardware-configuration.nix ];

  swapDevices = [
    {
      device = "/swapfile";
      size = 128 * 1024;
    }
  ];
  networking.useDHCP = true;

  networking = {
    hostName = "x86-merkat-freeipa";
	};
}
