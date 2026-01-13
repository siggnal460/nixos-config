{
  systemd.tmpfiles.rules = [
    "d /var/lib/vikunja/files 0770 vikunja wheel"
    "d /var/lib/vikunja/db 0770 vikunja wheel"
  ];

  users.users = {
    vikunja = {
      uid = 600;
      isSystemUser = true;
      group = "vikunja";
    };
  };

  users.groups = {
    vikunja = {
      gid = 600;
    };
  };

  virtualisation.oci-containers.containers = {
    vikunja = {
      image = "docker.io/vikunja/vikunja:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "3456:3456"
      ];
      environment = {
        VIKUNJA_SERVICE_PUBLICURL = "https://tasks.gappyland.org";
      };
      volumes = [
        "/var/lib/vikunja/files:/app/vikunja/files"
        "/var/lib/vikunja/db:/db"
      ];
      extraOptions = [
        "--name=vikunja"
      ];
    };
  };
}
