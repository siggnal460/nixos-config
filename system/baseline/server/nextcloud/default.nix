let
  host = "x86-rakmnt-mediaserver";
in
{
  imports = [ ../../../shared/podman.nix ];

  systemd.tmpfiles.rules = [
    "d /etc/nextcloud 0774 nextcloud nextcloud"
    "d /etc/nextcloud-mariadb 0774 nextcloud nextcloud"
    "d /export/nextcloud 0774 nextcloud nextcloud"
  ];

  services.nfs.server = {
    exports = ''/export/nextcloud 10.0.0.15(rw,nohide,insecure,no_subtree_check)'';
  };

  users.users = {
    nextcloud = {
      uid = 760;
      isSystemUser = true;
      group = "nextcloud";
    };
  };

  users.groups = {
    nextcloud = {
      gid = 760;
    };
  };

  virtualisation.oci-containers.containers = {
    nextcloud = {
      image = "lscr.io/linuxserver/nextcloud:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "443:443"
      ];
      environment = {
        PUID = "760";
        PGID = "760";
        TZ = "America/Denver";
      };
      volumes = [
        "/etc/nextcloud:/config"
        "/export/nextcloud:/data"
      ];
      extraOptions = [
        "--name=nextcloud"
      ];
    };
    #nextcloud-mariadb = {
    #  image = "lscr.io/linuxserver/mariadb:latest";
    #  autoStart = true;
    #  labels = {
    #    "io.containers.autoupdate" = "registry";
    #  };
    #  ports = [
    #    "3306:3306"
    #  ];
    #  environment = {
    #    PUID = "760";
    #    PGID = "760";
    #    TZ = "America/Denver";
    #  };
    #  volumes = [
    #    "/etc/nextcloud-mariadb:/config"
    #  ];
    #  extraOptions = [
    #    "--name=nextcloud-mariadb"
    #  ];
    #};

    #sops.secrets = {
    #  "${host}/nextcloud/admin_db_password".owner = "nextcloud";
    #};
  };
}
