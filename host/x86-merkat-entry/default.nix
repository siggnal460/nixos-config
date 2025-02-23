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
      image = "henrygd/beszel-agent";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "8090:8090"
      ];
      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock:ro"
      ];
      environment = {
        PORT = "45876";
        KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMvz32rDPSRNQlyuSXO3wvz6MlbMdiMUeJvQcgtg+5T5";
      };
      extraOptions = [
        "--name=beszel-agent"
        "--network=host"
      ];
    };
  };

}
