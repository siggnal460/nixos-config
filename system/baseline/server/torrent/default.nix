{
  systemd.tmpfiles.rules = [
    "d /export/media/downloads 0770 transmission media"
    "d /export/media/appdata/transmission/data 0770 transmission transmission"
  ];

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
