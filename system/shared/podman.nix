{ pkgs, ... }:
{
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = [ "all" ];
      };
    };
  };

  virtualisation.oci-containers.containers = {
    watchtower = {
      image = "docker.io/containrrr/watchtower:latest";
      volumes = [ "/var/run/podman/podman.sock:/var/run/docker.sock:rw" ];
    };
  };

  virtualisation.oci-containers.backend = "podman";

  environment.systemPackages = [ pkgs.podman-compose ];
}
