{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.blender.override {
      cudaSupport = true;
    })
  ];
}
