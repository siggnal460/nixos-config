{
  systemd.tmpfiles.rules = [
    "d /export/media/torrents 0770 deluge media"
    "d /export/media/torrents/complete 0770 deluge media"
    "d /export/media/torrents/complete/anime 0770 deluge media"
    "d /export/media/torrents/complete/anime-movies 0770 deluge media"
    "d /export/media/torrents/complete/books 0770 deluge media"
    "d /export/media/torrents/complete/tvshows 0770 deluge media"
    "d /export/media/torrents/complete/movies 0770 deluge media"
    "d /export/media/torrents/incomplete 0770 deluge media"
    "d /export/media/usenet 0770 nzbget media"
    "d /export/media/usenet/completed 0770 nzbget media"
    "d /export/media/usenet/completed/Anime 0770 nzbget media"
    "d /export/media/usenet/completed/Movies 0770 nzbget media"
    "d /export/media/usenet/completed/Series 0770 nzbget media"
    #"d /export/media/youtube 0770 pinchflat media"
    "d /etc/deluge 0750 deluge wheel"
    "d /etc/nzbget 0750 nzbget wheel"
    #"d /etc/pinchflat 0750 pinchflat wheel"
  ];

  imports = [ ../../../shared/podman.nix ];

  #networking.firewall.allowedTCPPorts = [ 51413 ];

  #networking.firewall.allowedUDPPorts = [ 51413 ];

  services.clamav.scanner.scanDirectories = [
    "/export/media/torrents"
    "/export/media/usenet"
  ];

  users.users = {
    deluge = {
      uid = 710;
      isSystemUser = true;
      group = "media";
    };
    nzbget = {
      uid = 711;
      isSystemUser = true;
      group = "media";
    };
    #pinchflat = {
    #  uid = 712;
    #  isSystemUser = true;
    #  group = "media";
    #};
  };

  virtualisation.oci-containers.containers = {
    #pinchflat = {
    #  image = "ghcr.io/kieraneglin/pinchflat:latest";
    #  autoStart = true;
    #  labels = {
    #    "io.containers.autoupdate" = "registry";
    #  };
    #  ports = [
    #    "8945:8945"
    #  ];
    #  environment = {
    #    PUID = "712";
    #    PGID = "982";
    #    TZ = "America/Denver";
    #  };
    #  volumes = [
    #    "/export/media/youtube:/downloads"
    #    "/etc/pinchflat:/config"
    #  ];
    #  extraOptions = [
    #    "--name=pinchflat"
    #  ];
    #};

    deluge = {
      image = "lscr.io/linuxserver/deluge:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "8112:8112"
        "49154:6881"
        "49154:6881/udp"
      ];
      environment = {
        PUID = "710";
        PGID = "982";
        TZ = "America/Denver";
      };
      volumes = [
        "/export/media/torrents:/downloads"
        "/etc/deluge:/config"
      ];
      extraOptions = [
        "--name=deluge"
      ];
    };

    nzbget = {
      image = "lscr.io/linuxserver/nzbget:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "6789:6789"
      ];
      environment = {
        PUID = "711";
        PGID = "982";
        TZ = "America/Denver";
      };
      volumes = [
        "/export/media/usenet:/data/usenet"
        "/etc/nzbget:/config"
      ];
      extraOptions = [
        "--name=nzbget"
      ];
    };
  };
}
