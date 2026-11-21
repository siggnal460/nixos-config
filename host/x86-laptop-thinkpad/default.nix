{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../user/aaron
    ../../user/aaron/workstation
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
