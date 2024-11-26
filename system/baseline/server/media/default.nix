{
  systemd.tmpfiles.rules = [
    "d /oci_cache 0775 root root"
    "d /oci_cache/jellyfin 0700 jellyfin media"
    "d /oci_cache/radarr 0700 radarr media"
    "d /oci_cache/sonarr 0700 sonarr media"
    "d /oci_cache/prowlarr 0700 prowlarr media"

    "d /mnt 0775 root root"
    "d /mnt/torrent-downloads 0755 root media"

    "d /export/config 0775 root root"
    "d /export/config/jellyfin 0700 jellyfin media"
    "d /export/config/radarr 0700 radarr media"
    "d /export/config/sonarr 0700 sonarr media"
    "d /export/config/prowlarr 0700 prowlarr media"

    "d /export/media 0770 root media"
    "d /export/media/books 0770 root media"
    "d /export/media/movies 0770 root media"
    "d /export/media/music 0770 root media"
    "d /export/media/tvshows 0770 root media"
  ];

  networking.firewall.allowedTCPPorts = [
    8096 # jellyfin
    7878 # radarr
    8989 # sonarr
    9696 # prowlarr
  ];

  users.users = {
    jellyfin = {
      uid = 1500;
      group = "media";
      createHome = false;
      isSystemUser = true;
    };
    radarr = {
      uid = 1501;
      group = "media";
      createHome = false;
      isSystemUser = true;
    };
    sonarr = {
      uid = 1502;
      group = "media";
      createHome = false;
      isSystemUser = true;
    };
    prowlarr = {
      uid = 1503;
      group = "media";
      createHome = false;
      isSystemUser = true;
    };
  };

  services.nfs.server = {
    exports = ''/export/media 10.0.0.10(rw,nohide,insecure,no_subtree_check)'';
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
        "7359:7359"
        "1900:1900"
      ];
      environment = {
        PUID = "1500";
        PGID = "1500";
        TZ = "America/Denver";
      };
      volumes = [
        "/export/books:/data/books"
        "/export/movies:/data/movies"
        "/export/music:/data/music"
        "/export/tvshows:/data/tvshows"
        "/oci_cache/jellyfin:/cache"
        "/export/config/jellyfin:/config"
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
        PUID = "1501";
        PGID = "1500";
        TZ = "America/Denver";
      };
      volumes = [
        "/export/movies:/movies"
        "/mnt/torrent-downloads:/downloads"
        "/oci_cache/radarr:/cache"
        "/export/config/radarr:/config"
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
        PUID = "1502";
        PGID = "1500";
        TZ = "America/Denver";
      };
      volumes = [
        "/export/tv:/tv"
        "/mnt/torrent-downloads:/downloads"
        "/oci_cache/sonarr:/cache"
        "/export/config/sonarr:/config"
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
        PUID = "1503";
        PGID = "1500";
        TZ = "America/Denver";
      };
      volumes = [
        "/oci_cache/prowlarr:/cache"
        "/export/config/prowlarr:/config"
      ];
    };
  };
}
