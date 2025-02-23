{
  imports = [
    ./hardware-configuration.nix
    ../../system/shared/podman.nix
  ];

  networking = {
    hostName = "x86-merkat-entry";
    domain = "gappyland.org";
  };

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
        KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGXz3a6nV8xxYD5tomKiPul/RTuaAK2s51cGzxgv/X1s";
      };
      extraOptions = [
        "--name=beszel-agent"
        "--network=host"
      ];
    };
  };

}
