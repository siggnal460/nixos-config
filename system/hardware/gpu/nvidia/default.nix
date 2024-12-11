{ config, ... }:
{
  nixpkgs.config.allowUnfree = true;

  boot = {
    kernelModules = [ "nvidia-uvm" ];
    kernelParams = [
      "module_blacklist=i915"
      "module_blacklist=amdgpu"
      "nvidia_drm.modeset=1"
      "nvidia_drm.fbdev=1"
    ];
  };

  #hardware.graphics = {
  #  enable = true;
  #  enable32Bit = true;
  #};

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.finegrained = false;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  #environment.systemPackages = with pkgs; [
  #  nvtopPackages.full
  #];
}
