{
  systemd.tmpfiles.rules = [
    "d /etc/emulatorjs 0700 emulatorjs emulatorjs"
    "d /export/emulatorjs 0775 emulatorjs emulatorjs"
    "d /export/emulatorjs/data 0770 emulatorjs users"
    "Z /export/emulatorjs/data 0770 emulatorjs users"
  ];

  services = {
    nfs.server = {
      exports = ''/export/emulatorjs 10.0.0.15(rw,nohide,insecure,no_subtree_check)'';
    };
  };

  users = {
    users = {
      emulatorjs = {
        uid = 800;
        isSystemUser = true;
        group = "emulatorjs";
      };
    };
    groups."emulatorjs" = {
      gid = 800;
    };
  };

  virtualisation.oci-containers.containers = {
    emulatorjs = {
      image = "lscr.io/linuxserver/emulatorjs:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "3001:3000"
        "81:80"
      ];
      environment = {
        PUID = "800";
        PGID = "800";
        TZ = "America/Denver";
      };
      volumes = [
        "/etc/emulatorjs:/config"
        "/export/emulatorjs/data:/data"
      ];
      extraOptions = [
        "--name=emulatorjs"
      ];
    };
  };
}
