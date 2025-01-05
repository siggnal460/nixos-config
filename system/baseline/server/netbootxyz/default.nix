{
  systemd.tmpfiles.rules = [
    "d /etc/netbootxyz 0774 netbootxyz netbootxyz"
    "d /export/netbootxyz/assets 0775 netbootxyz netbootxyz"
  ];

  users.users = {
    netbootxyz = {
      uid = 750;
      isSystemUser = true;
      group = "netbootxyz";
    };
  };

  users.groups = {
    netbootxyz = {
      gid = 750;
    };
  };

  virtualisation.oci-containers.containers = {
    netbootxyz = {
      image = "lscr.io/linuxserver/netbootxyz:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "3000:3000"
        "69:69"
        "8080:80"
      ];
      environment = {
        PUID = "750";
        PGID = "750";
        TZ = "America/Denver";
        WEB_APP_PORT = "3000";
        NGINX_PORT = "80";
      };
      volumes = [
        "/etc/netbootxyz:/config"
        "/export/netbootxyz/assets:/assets"
      ];
      extraOptions = [
        "--name=netbootxyz"
      ];
    };
  };
}
