{ lib, ... }:
let
  hostname = "arm-raspi4-downloadclient";
in
{
  imports = [ ./hardware-configuration.nix ];

  sops.defaultSopsFile = ../../secrets/${hostname}/secrets.yaml;

  networking = {
    hostName = hostname;
    domain = "gappyland.org";
  };

  systemd.timers."podman-updater".timerConfig.OnCalendar = lib.mkForce "*-*-* 02:30:00";
}
