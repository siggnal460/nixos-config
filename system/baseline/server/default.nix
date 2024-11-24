{
  imports = [
    ../../shared/remotely-managed.nix
    ../../shared/podman.nix
  ];

  networking.wireless.enable = false;

  hardware.bluetooth = {
    enable = false;
    powerOnBoot = false;
  };
}
