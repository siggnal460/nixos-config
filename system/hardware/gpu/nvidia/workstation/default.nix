{ pkgs, ... }:
{
  environment.systemPackages = [ (pkgs.blender.override { cudaSupport = true; }) ];

  hardware.nvidia.nvidiaSettings = true;
}
