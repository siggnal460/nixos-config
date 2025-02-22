{
  systemd.tmpfiles.rules = [
    "d /etc/nextcloud 0700 nextcloud nextcloud"
    "d /etc/nextcloud-mariadb 0700 nextcloud-mariadb nextcloud"
    "d /export/nextcloud 0700 nextcloud nextcloud"
  ];

  users = {
    users = {
      nextcloud = {
        uid = 900;
        isSystemUser = true;
        group = "nextcloud";
      };
      nextcloud-mariadb = {
        uid = 901;
        isSystemUser = true;
        group = "nextcloud";
      };
    };
    groups = {
      nextcloud = {
        gid = 900;
      };
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
        PUID = "900";
        PGID = "900";
        TZ = "America/Denver";
      };
      volumes = [
        "/etc/nextcloud:/config"
        "/export/nextcloud:/data"
      ];
      extraOptions = [
        "--name=nextcloud"
      ];
      dependsOn = [
        "nextcloud-mariadb"
      ];
    };

    nextcloud-mariadb = {
      image = "lscr.io/linuxserver/mariadb:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      environmentFiles = [
        "/run/secrets/nextcloud/mariadb_secrets"
      ];
      environment = {
        PUID = "901";
        PGID = "900";
        TZ = "America/Denver";
        MYSQL_DATABASE = "nextcloud";
        MYSQL_USER = "nextcloud";
      };
      volumes = [
        "/etc/nextcloud-mariadb:/config"
      ];
      extraOptions = [
        "--name=nextcloud-mariadb"
      ];
    };
  };

  sops.secrets = {
    "nextcloud/mariadb_secrets".owner = "nextcloud-mariadb";
  };
}
