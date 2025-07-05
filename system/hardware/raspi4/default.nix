{ inputs, pkgs, ... }:
{
  imports = [ inputs.nixos-hardware.nixosModules.raspberry-pi-5 ];

	boot = {
		# The Linux kernel version
		kernelPackages = pkgs.linuxPackages_rpi4;
		# Options to enable serial console and more
		kernelParams = [
			"8250.nr_uarts=1"
			"console=tyAMA0,115200"
			"console=tty1"
			"cma=128M"
		];

		# The bootloader
		loader = {
			raspberryPi = {
				enable = true;
				version = 4;
			};

			# Use extlinux, whereas the NixOS default is Grub
			grub.enable = false;

			# Enables the generation of /boot/extlinux/extlinux.conf
			generic-extlinux-compatible.enable = true;
		};
	};

	hardware = {
    raspberry-pi."4".apply-overlays-dtmerge.enable = true;
    deviceTree = {
      enable = true;
      filter = "*rpi-4-*.dtb";
    };
  };
  console.enable = false;
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
		raspberrypifw
  ];
}
