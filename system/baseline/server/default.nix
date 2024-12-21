{
  imports = [
    ../../shared/remotely-managed.nix
    ../../shared/podman.nix
  ];

  networking.wireless.enable = false;

  services = {
    clamav = {
      daemon.enable = true;
      scanner.enable = true;
      updater.enable = true;
      fangfrish.enable = true;
    };
  };

  hardware.bluetooth = {
    enable = false;
    powerOnBoot = false;
  };
}
