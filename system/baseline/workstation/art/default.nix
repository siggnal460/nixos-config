{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    blender
    gimp
    inkscape
    krita
    libresprite
    upscayl
  ];
}
