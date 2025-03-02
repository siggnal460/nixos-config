{
  systemd.tmpfiles.rules = [
    "d /etc/pihole 0700 root root"
  ];

  virtualisation.oci-containers.containers = {
    pihole = {
      image = "docker.io/pihole/pihole:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "53:53/tcp"
        "53:53/udp"
        "80:80/tcp"
        "443:443/tcp"
      ];
      environmentFiles = [ "/run/secrets/pihole_secrets" ];
      environment = {
        TZ = "America/Denver";
        FTLCONF_dns_listeningMode = "1";
      };
      volumes = [
        "/etc/pihole:/etc/pihole"
      ];
      extraOptions = [
        "--name=pihole"
      ];
    };
  };

  sops.secrets = {
    "pihole_secrets".owner = "root";
  };
}
