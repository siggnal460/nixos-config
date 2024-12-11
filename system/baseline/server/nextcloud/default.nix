{
  systemd.tmpfiles.rules = [ "d /exports/nextcloud-data 0664 nextcloud nextcloud" ];

  services.nextcloud = {
    enable = true;
    datadir = "/exports/nextcloud-data";
  };
}
