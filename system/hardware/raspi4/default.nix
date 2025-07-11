{ lib, ... }:
{
  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 4*1024;
  } ];

  nix.settings.cores = 3;

  boot = {
    initrd.systemd.enableTpm2 = false;
    loader = {
      grub.enable = lib.mkForce false;
      systemd-boot.enable = lib.mkForce false;
      generic-extlinux-compatible = {
			  enable = lib.mkForce true;
				configurationLimit = lib.mkForce 2;
			};
    };
  };

  services.clamav = { # too much RAM
    daemon.enable = lib.mkForce false;
    updater.enable = lib.mkForce false;
    fangfrisch.enable = lib.mkForce false;
  };
}
