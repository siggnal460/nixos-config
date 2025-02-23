{ config, ... }:
{
  imports = [ ../../../../system/shared/podman.nix ];

  networking.firewall.allowedTCPPorts = [ 45876 ];

  virtualisation.oci-containers.containers = {
    beszel-agent = {
      image = "docker.io/henrygd/beszel-agent";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      volumes = [
        "/var/run/podman/podman.sock:/var/run/docker.sock:ro"
      ];
      environment = {
        PORT = "45876";
        KEY = config.beszel-agent.publicKey;
      };
      extraOptions = [
        "--name=beszel-agent"
        "--network=host"
      ];
    };
  };
}
