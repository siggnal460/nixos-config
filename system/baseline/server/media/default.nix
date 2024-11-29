{
  systemd.tmpfiles.rules = [
    "d /export/media 0770 root media"
    "d /export/media/books 0770 root media"
    "d /export/media/movies 0770 root media"
    "d /export/media/music 0770 root media"
    "d /export/media/tvshows 0770 root media"
  ];

  services.nfs.server = {
    exports = ''/export/media 10.0.0.10(rw,nohide,insecure,no_subtree_check)'';
  };

  users.users = {
    jellyfin = {
      extraGroups = "media";
    };
    radarr = {
      extraGroups = "media";
    };
    sonarr = {
      extraGroups = "media";
    };
    prowlarr = {
      extraGroups = "media";
    };
  };

  services = {
    deluge.web = {
      enable = true;
    };
    jellyfin = {
      enable = true;
    };
    jellyseerr.enable = true;
    radarr.enable = true;
    sonarr.enable = true;
    prowlarr.enable = true;
  };
}
