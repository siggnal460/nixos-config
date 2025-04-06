{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  swapDevices = [
    {
      device = "/swapfile";
      size = 128 * 1024;
    }
  ];

  sops.defaultSopsFile = ../../secrets/x86-atxtwr-computeserver/secrets.yaml;

  networking = {
    hostName = "x86-atxtwr-computeserver";
    interfaces.enp8s0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "10.0.0.10";
          prefixLength = 12;
        }
      ];
    };
    defaultGateway = {
      address = "10.0.0.1";
      interface = "enp8s0";
    };
  };

  systemd = {
    timers = {
      podman-updater = {
        timerConfig = {
          Unit = "podman-updater.service";
          OnCalendar = "*-*-* 00:30:00";
        };
        wantedBy = [ "timers.target" ];
      };
    };
    services.podman-updater = {
      description = "Service that runs daily to update all podman containers";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
      };
      script = "${pkgs.sudo}/bin/sudo ${pkgs.podman}/bin/podman auto-update";
    };
  };
}
