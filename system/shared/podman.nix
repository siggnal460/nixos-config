{ pkgs, lib, ... }:
{
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
      autoPrune = {
        enable = true;
        dates = "Tue *-*-* 00:45:00";
        flags = [ "--all" ];
      };
    };
  };

  virtualisation.oci-containers.backend = "podman";

  systemd = {
    timers = {
      podman-updater = {
        timerConfig = {
          Unit = "podman-updater.service";
          OnCalendar = lib.mkDefault "*-*-* 10:45:00";
        };
        wantedBy = [ "timers.target" ];
      };
    };
    services.podman-updater = {
      description = "Podman Container Daily Updater";
      serviceConfig = {
        User = "root";
        Type = "oneshot";
      };
      script = "${pkgs.podman}/bin/podman auto-update";
    };
  };
}
