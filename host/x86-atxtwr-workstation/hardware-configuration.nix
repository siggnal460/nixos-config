# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/5e47133e-bf2a-401a-a53a-dc791d422eea";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-0961b6fb-99d5-401b-9c0c-94d79014c252".device =
    "/dev/disk/by-uuid/0961b6fb-99d5-401b-9c0c-94d79014c252";

  fileSystems."/nfs/ai" = {
    device = "systemd-1";
    fsType = "autofs";
  };

  fileSystems."/nfs/blender" = {
    device = "systemd-1";
    fsType = "autofs";
  };

  fileSystems."/nfs/media" = {
    device = "systemd-1";
    fsType = "autofs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/EA14-F1E5";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  fileSystems."/mnt/nvme0n1" = {
    device = "/dev/disk/by-uuid/5b778bef-b3af-4710-9d44-6424b693dc29";
    fsType = "ext4";
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp8s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.podman0.useDHCP = lib.mkDefault true;
  # networking.interfaces.veth0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp7s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
