{ lib, ... }:
{
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 5 * 1024; # pushes the 2GB model to 8GB total including zram, necessary for builds to not fail
    }
  ];

  nix.settings = {
    cores = 1;
    max-jobs = 1;
  };

  boot = {
    initrd.systemd.tpm2.enable = false;
    loader = {
      grub.enable = lib.mkForce false;
      systemd-boot.enable = lib.mkForce false;
      generic-extlinux-compatible = {
        enable = lib.mkForce true;
        configurationLimit = lib.mkForce 2;
      };
    };
  };

  services.clamav = {
    # way too much RAM
    daemon.enable = lib.mkForce false;
    updater.enable = lib.mkForce false;
    fangfrisch.enable = lib.mkForce false;
  };
}
