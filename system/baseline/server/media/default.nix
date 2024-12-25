{
  systemd.tmpfiles.rules = [
    "d /oci_cache/jellyfin 0770 jellyfin jellyfin"
    "d /export/media 0775 root root"
    "d /export/media/appdata 0775 root root"
    "d /export/media/appdata/bazarr/data 0770 bazarr users"
    "d /export/media/appdata/jellyfin/config 0770 jellyfin users"
    "d /export/media/appdata/jellyfin/data 0770 jellyfin users"
    "d /export/media/appdata/jellyseerr/data 0770 root users"
    "d /export/media/appdata/lidarr/data 0770 prowlarr users"
    "d /export/media/appdata/prowlarr/data 0770 prowlarr users"
    "d /export/media/appdata/radarr/data 0770 radarr users"
    "d /export/media/appdata/sonarr/data 0770 sonarr users"
    "d /export/media/appdata/sonarr-anime/data 0770 sonarr users"
    "d /export/media/anime 0770 root media"
    "d /export/media/books 0770 root media"
    "d /export/media/courses 0770 root media"
    "d /export/media/movies 0770 root media"
    "d /export/media/music 0770 root media"
    "d /export/media/tvshows 0770 root media"
    "d /export/media/downloads 0770 transmission media"
    "d /export/media/downloads/complete 0770 transmission media"
    "d /export/media/downloads/complete/anime 0770 transmission media"
    "d /export/media/downloads/complete/tvshows 0770 transmission media"
    "d /export/media/downloads/incomplete 0770 transmission media"
  ];

  services.nfs.server = {
    exports = ''/export/media 10.0.0.15(rw,nohide,insecure,no_subtree_check)'';
  };

  users.users = {
    jellyfin = {
      uid = 700;
      isSystemUser = true;
      group = "media";
    };
    radarr = {
      uid = 701;
      isSystemUser = true;
      group = "media";
    };
    jellyseerr = {
      uid = 702;
      isSystemUser = true;
      group = "media";
    };
    bazarr = {
      uid = 703;
      isSystemUser = true;
      group = "media";
    };
    prowlarr = {
      uid = 704;
      isSystemUser = true;
      group = "media";
    };
    sonarr = {
      uid = 705;
      isSystemUser = true;
      group = "media";
    };
    sonarr-anime = {
      uid = 706;
      isSystemUser = true;
      group = "media";
    };
  };

  virtualisation.oci-containers.containers = {
    jellyfin = {
      image = "lscr.io/linuxserver/jellyfin:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "8096:8096"
        "8920:8920"
        "7359:7359/udp"
        "1900:1900/udp"
      ];
      environment = {
        PUID = "700";
        PGID = "982";
        TZ = "America/Denver";
        NVIDIA_DRIVER_CAPABILITIES = "all";
        NVIDIA_VISIBLE_DEVICES = "1";
      };
      volumes = [
        "/oci_cache/jellyfin:/config/cache"
        "/export/media/appdata/jellyfin/config:/config"
        "/export/media/anime:/data/anime"
        "/export/media/books:/data/books"
        "/export/media/courses:/data/courses"
        "/export/media/tvshows:/data/tvshows"
        "/export/media/movies:/data/movies"
        "/export/media/music:/data/music"
      ];
      extraOptions = [
        "--name=jellyfin"
        "--gpus=1"
      ];
    };

    radarr = {
      image = "lscr.io/linuxserver/radarr:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "7878:7878"
      ];
      environment = {
        PUID = "701";
        PGID = "701";
        TZ = "America/Denver";
      };
      volumes = [
        "/export/media/appdata/radarr/data:/config"
        "/export/media/movies:/movies"
        "/export/media/downloads:/downloads"
      ];
      extraOptions = [
        "--name=radarr"
      ];
    };

    sonarr = {
      image = "lscr.io/linuxserver/sonarr:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "8989:8989"
      ];
      environment = {
        PUID = "705";
        PGID = "982";
        TZ = "America/Denver";
      };
      volumes = [
        "/export/media/appdata/sonarr/data:/config"
        "/export/media/tvshows:/tvshows"
        "/export/media/downloads:/downloads"
      ];
      extraOptions = [
        "--name=sonarr"
      ];
    };

    sonarr-anime = {
      image = "lscr.io/linuxserver/sonarr:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "8988:8989"
      ];
      environment = {
        PUID = "706";
        PGID = "982";
        TZ = "America/Denver";
      };
      volumes = [
        "/export/media/appdata/sonarr-anime/data:/config"
        "/export/media/anime:/tvshows"
        "/export/media/downloads:/downloads"
      ];
      extraOptions = [
        "--name=sonarr-anime"
      ];
    };

    bazarr = {
      image = "lscr.io/linuxserver/bazarr:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "6767:6767"
      ];
      environment = {
        PUID = "703";
        PGID = "982";
        TZ = "America/Denver";
      };
      volumes = [
        "/export/media/appdata/bazarr/data:/config"
        "/export/media/movies:/movies"
        "/export/media/tvshows:/tv"
      ];
      extraOptions = [
        "--name=bazarr"
      ];
    };

    prowlarr = {
      image = "lscr.io/linuxserver/prowlarr:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "9696:9696"
      ];
      environment = {
        PUID = "704";
        PGID = "982";
        TZ = "America/Denver";
      };
      volumes = [
        "/export/media/appdata/prowlarr/data:/config"
      ];
      extraOptions = [
        "--name=prowlarr"
      ];
    };

    jellyseerr = {
      image = "docker.io/fallenbagel/jellyseerr:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "5055:5055"
      ];
      environment = {
        PUID = "702";
        PGID = "982";
        TZ = "America/Denver";
      };
      volumes = [
        "/export/media/appdata/jellyseerr/data:/app/config"
      ];
      extraOptions = [
        "--name=jellyseerr"
      ];
    };

    flaresolverr = {
      image = "ghcr.io/flaresolverr/flaresolverr:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "8191:8191"
      ];
      environment = {
        TZ = "America/Denver";
      };
      extraOptions = [
        "--name=flaresolverr"
      ];
    };
  };
}
