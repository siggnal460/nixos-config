{
  imports = [
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "x86-atxtwr-computeserver";
    #interfaces.enp8s0 = {
    #  useDHCP = false;
    #  ipv4.addresses = [
    #    {
    #      address = "10.0.0.10";
    #      prefixLength = 12;
    #    }
    #  ];
    #};
    #defaultGateway = {
    #  address = "10.0.0.1";
    #  interface = "enp8s0";
    #};
  };

  systemd.timers."podman-updater".timerConfig.OnCalendar = "*-*-* 00:00:00";
}
