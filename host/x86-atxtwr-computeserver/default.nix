{ lib, ... }:
let
  hostname = "x86-atxtwr-computeserver";
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  sops = {
    defaultSopsFile = ../../secrets/${hostname}/secrets.yaml;
  };

  networking = {
    hostName = hostname;
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

  systemd.timers."podman-updater".timerConfig.OnCalendar = lib.mkForce "*-*-* 00:00:00";
}
