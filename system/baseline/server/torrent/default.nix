{
  systemd.tmpfiles.rules = [
    "d /export/media/downloads 0770 transmission media"
    "d /export/media/appdata/transmission/data 0770 transmission transmission"
  ];

  imports = [ ../../../shared/podman.nix ];

  networking.firewall.allowedTCPPorts = [ 51413 ];

  networking.firewall.allowedUDPPorts = [ 51413 ];

  users.users = {
    transmission = {
      uid = 710;
      isSystemUser = true;
      group = "transmission";
      extraGroups = [ "media" ];
    };
  };

  users.groups = {
    transmission = {
      gid = 710;
    };
  };

  virtualisation.oci-containers.containers = {
    transmission = {
      image = "lscr.io/linuxserver/transmission:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "9091:9091"
        "51413:51413"
        "51413:51413/udp"
      ];
      environment = {
        PUID = "710";
        PGID = "710";
        TZ = "America/Denver";
        PEERPORT = "51413";
      };
      volumes = [
        "/export/media/downloads:/downloads"
        "/export/media/appdata/transmission/data:/config"
      ];
      extraOptions = [
        "--name=transmission"
      ];
    };
  };

}
