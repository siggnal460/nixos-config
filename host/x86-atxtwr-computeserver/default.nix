{
  imports = [
    ./hardware-configuration.nix
  ];

  swapDevices = [
    {
      device = "/swapfile";
      size = 128 * 1024;
    }
  ];

  networking = {
    hostName = "x86-atxtwr-computeserver";
    #interfaces.enp7s0 = {
    #useDHCP = false;
    #ipv4.addresses = [{
    #address = "10.6.0.1";
    #prefixLength = 12;
    #}];
    #};
  };

}
