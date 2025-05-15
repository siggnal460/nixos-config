{ config, ... }:
{
  nixpkgs.config.allowUnfree = true;

  boot = {
    initrd.kernelModules = [
      "nvidia"
      "nvidia-modeset"
      "nvidia-drm"
    ];
    kernelParams = [
      "module_blacklist=i915"
      "module_blacklist=amdgpu"
      "nvidia_drm.modeset=1"
      "nvidia_drm.fbdev=1"
    ];
    blacklistedKernelModules = [ "nouveau" ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    graphics = {
      enable = true;
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement.finegrained = false;
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };
}
