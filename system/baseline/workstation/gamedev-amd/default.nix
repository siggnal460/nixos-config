{ pkgs, ... }:
{
  imports = [ ../../../shared/blender-amd.nix ];

  #hardware.opentabletdriver.enable = true;

  environment.systemPackages = with pkgs; [
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
  ];
}
