{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "x86-thnkpd-netman";
    interface.eth0.ipv4.addresses = [
      {
        address = "10.1.0.1";
        prefixLength = 12;
      }
    ];
  };
}
