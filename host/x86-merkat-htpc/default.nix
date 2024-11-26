{
  imports = [
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "x86-merkat-testserv";
    /*
      interfaces."enp88s0".ipv4.addresses = [
        {
          address = "10.5.0.1";
          prefixLength = 12;
        }
      ];
    */
  };
}
