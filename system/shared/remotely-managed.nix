{ lib, ... }:
{
  imports = [ ./podman.nix ];

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
        KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGXz3a6nV8xxYD5tomKiPul/RTuaAK2s51cGzxgv/X1s";
      };
      extraOptions = [
        "--name=beszel-agent"
        "--network=host"
      ];
    };
  };

  services = {
    openssh = {
      enable = lib.mkForce true;
      authorizedKeysInHomedir = true;
      allowSFTP = true; # needed for ansible
      settings = {
        X11Forwarding = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
      openFirewall = true;
    };
    fail2ban = {
      # monitors ssh logs by default
      enable = true;
      ignoreIP = [ "10.0.0.0/12" ];
    };
  };
}
