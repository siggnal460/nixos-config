{
  systemd.tmpfiles.rules = [
    "d /oci_cache/jellyfin 0770 root users"
    "d /export/media 0770 root users"
    "d /export/media/appdata 0770 root users"
    "d /export/media/appdata/jellyfin/config 0770 root users"
    "d /export/media/appdata/jellyfin/data 0770 root users"
    "d /export/media/appdata/sonarr/data 0770 root users"
    "d /export/media/appdata/radarr/data 0770 root users"
    "d /export/media/appdata/jellyseerr/data 0770 root users"
    "d /export/media/appdata/bazarr/data 0770 root users"
    "d /export/media/anime 0770 root users"
    "d /export/media/books 0770 root users"
    "d /export/media/courses 0770 root users"
    "d /export/media/movies 0770 root users"
    "d /export/media/music 0770 root users"
    "d /export/media/tvshows 0770 root users"
  ];

  services.nfs.server = {
    exports = ''/export/media 10.0.0.8(rw,nohide,insecure,no_subtree_check)'';
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
        PUID = "1000";
        PGID = "1000";
        TZ = "America/Denver";
        NVIDIA_VISIBLE_DEVICES = "all";
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
        "--group-add=users"
      ];
    };
  };
}
