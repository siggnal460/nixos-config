{ pkgs, ... }:
{
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = [ "all" ];
      };
    };
  };

  virtualisation.oci-containers.backend = "podman";

  #systemd = {
  #  timers = {
  #    podman-updater = {
  #      timerConfig = {
  #        Unit = "podman-updater.service";
  #        OnCalendar = "*-*-* 4:00:00";
  #      };
  #      wantedBy = [ "timers.target" ];
  #    };
  #  };
  #  services.podman-updater = {
  #    description = "Service that runs daily to update all podman containers";
  #    wantedBy = [ "multi-user.target" ];
  #    serviceConfig = {
  #      Type = "oneshot";
  #    };
  #    script = "${pkgs.sudo}/bin/sudo ${pkgs.podman}/bin/podman auto-update";
  #  };
  #};
}
