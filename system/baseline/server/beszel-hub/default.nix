{
  imports = [ ../../../shared/podman.nix ];

  systemd.tmpfiles.rules = [
    "d /var/lib/beszel 0774 root root"
  ];

  virtualisation.oci-containers.containers = {
    beszel-hub = {
      image = "docker.io/henrygd/beszel";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "8090:8090"
      ];
      volumes = [
        "/var/lib/beszel:/beszel_data"
      ];
      extraOptions = [
        "--name=beszel-hub"
      ];
    };
  };

}
