{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    audacity
    ardour
    godot
  ];
}
