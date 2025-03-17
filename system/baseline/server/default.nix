{ pkgs, ... }:
{
  imports = [
    ../../shared/remotely-managed.nix
  ];

  networking.wireless.enable = false;

  beszel-agent.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGXz3a6nV8xxYD5tomKiPul/RTuaAK2s51cGzxgv/X1s";

  systemd.tmpfiles.rules = [
    "d /mnt/backups 0775 restic restic"
  ];

  services = {
    clamav = {
      daemon.enable = true;
      scanner = {
        enable = true;
        interval = "*-*-* 01:45:00";
        scanDirectories = [
          "/etc"
          "/home"
          "/tmp"
          "/var/lib"
          "/var/tmp"
        ];
      };
      updater.enable = true;
      fangfrisch.enable = true;
    };
  };

  hardware.bluetooth = {
    enable = false;
    powerOnBoot = false;
  };

  environment.systemPackages = [
    pkgs.waypipe
  ];
}
