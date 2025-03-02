{ config, ... }:
{
  imports = [ ../../../shared/podman.nix ];

  systemd.tmpfiles.rules = [
    "d /var/lib/habittrove 0775 1001 1001"
  ];

  virtualisation.oci-containers.containers = {
    habittrove = {
      image = "docker.io/dohsimpson/habittrove:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "3002:3000"
      ];
      environmentFiles = [
        config.sops.secrets."habittrove_secrets".path
      ];
      volumes = [
        "/var/lib/habittrove:/app/data"
      ];
      extraOptions = [
        "--name=habittrove"
      ];
    };
  };

  sops.secrets."habittrove_secrets" = {
    format = "yaml";
  };
}
