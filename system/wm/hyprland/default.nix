{ pkgs, ... }:
{
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };
  };

  environment.systemPackages = [
    pkgs.grimblast
  ];
}
