{ pkgs, ... }:
{
  hardware.opentabletdriver.enable = true;

  environment.systemPackages = with pkgs; [
    audacity
    #ardour
    blender-hip
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
