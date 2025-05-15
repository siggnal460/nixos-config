{ pkgs, ... }:
{
  #TODO ADD BLENDER LATER
  environment.systemPackages = with pkgs; [
    audacity
    ardour
    godot_4
    inkscape
    kdePackages.kdenlive
    krita
    libresprite
    makehuman
    upscayl
  ];
}
