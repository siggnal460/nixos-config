{
  imports = [ ./hardware-configuration.nix ];

  networking = {
    hostName = "x86-merkat-bedhtpc";
    interfaces."enp88s0".ipv4.addresses = [
      {
        address = "10.6.0.4";
        prefixLength = 12;
      }
    ];
  };
}
