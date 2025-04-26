{ pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [
    6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
    # 2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
    # 2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
  ];
  networking.firewall.allowedUDPPorts = [
    # 8472 # k3s, flannel: required if using multi-node for inter-node networking
  ];
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [ ]; # "--debug" # Optionally add additional args to k3s
    clusterInit = true;
    images = [
      (pkgs.dockerTools.pullImage {
        imageName = "docker.io/caddy/caddy:latest";
        imageDigest = "sha256:d17c155b627f4ae14cef9cb4143b63c529a8497966b62febcde79f4ecc3857f7";
      })
    ];
  };
}
