{ pkgs, ... }:
{
  imports = [
    ../../shared/remotely-managed.nix
  ];

  environment.sessionVariables = {
    NIGHTLY_REFRESH = "reboot-if-needed";
  };

  networking.wireless.enable = false;

  systemd.tmpfiles.rules = [
    "d /mnt/backups 0775 restic restic"
  ];

  services = {
    clamav = {
      daemon.enable = true;
      scanner = {
        enable = true;
        interval = "*-*-* 01:00:00";
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
