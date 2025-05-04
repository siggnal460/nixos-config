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
      allowSFTP = true; # needed for ansible
      settings = {
        X11Forwarding = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
      knownHosts = {
        "x86-rakmnt-mediaserver".publicKey =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBGy+YGfa+dCd7S9Jm6hXWW+TQqgjdPIUlP2+ijZTCqc aaron@x86-rakmnt-mediaserver";
        "x86-atxtwr-computeserver".publicKey =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPHWbfQRrluSlaCohXm8/Qvpx1a80N4IEGHF8koRAdDZ aaron@x86-atxtwr-computeserver";
        "x86-merkat-auth".publicKey =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILudmn/T9/m1Sb1jzDN/WX5lroyoUhZw3amSEWhFbPWk aaron@x86-merkat-auth";
        "x86-merkat-entry".publicKey =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJ3ENb2iqe0ZgY+31q4+alGbWdFW5IEI3pznl8gBfAW aaron@x86-merkat-entry";
        "x86-minitx-jovian".publicKey =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINeYyHUVTW8PW6ipa+meN0DDlB6HXmAbHEnhfxdan+IW aaron@x86-minitx-jovian";
        "x86-stmdck-jovian".publicKey =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII7eGbYxgJi+4wDmKWPxg0lnWDET8Lmns8TfnCyaG/6r aaron@x86-stmdck-jovian";
        "x86-merkat-htpc".publicKey =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExo/6fWz0F9ofC/73eff34LALKalVP63bzAyiIZeJFF aaron@x86-merkat-htpc";
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
