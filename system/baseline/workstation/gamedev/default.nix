{ config, pkgs, ... }:
{
  imports = [ ../../../shared/comfyui.nix ];

  hardware.opentabletdriver.enable = true;

  environment.systemPackages =
    with pkgs;
    [
      audacity
      ardour
      godot_4
      inkscape
      kdePackages.kdenlive
      krita
      handbrake
      libresprite
      makehuman
      upscayl
    ]
    ++ (
      if (builtins.elem "amdgpu" config.boot.initrd.kernelModules) then
        [ blender-hip ]
      else
        (
          if (builtins.elem "nvidia" config.boot.initrd.kernelModules) then
            [ (blender.override { cudaSupport = true; }) ]
          else
            [ ]
        )
    );
}
