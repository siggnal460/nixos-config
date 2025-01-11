{
  systemd.tmpfiles.rules = [
    "d /var/lib/ipa-data 0774 freeipa freeipa"
  ];

  users.users = {
    freeipa = {
      uid = 800;
      isSystemUser = true;
      group = "freeipa";
    };
  };

  users.groups = {
    freeipa = {
      gid = 800;
    };
  };

  virtualisation.oci-containers.containers = {
    freeipa = {
      image = "docker.io/freeipa/freeipa-server:almalinux-9";
      autoStart = true;
      hostname = "x86-merkat-entry.gappyland.org";
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "53:53"
        "53:53/udp"
        "80:80"
        "88:88"
        "88:88/udp"
        "123:123"
        "389:389"
        "443:443"
        "464:464"
        "464:464/udp"
        "636:636"
      ];
      environment = {
        PUID = "800";
        PGID = "800";
        IPA_SERVER_IP = "10.0.0.11"; # fix later
      };
      volumes = [
        "/var/lib/ipa-data:/data"
      ];
      extraOptions = [
        "--name=freeipa"
        "--read-only"
      ];
      cmd = [
        "-U"
        "-r GAPPYLAND.ORG"
        "--no-ntp"
      ];
    };
  };
}
