{ pkgs, ... }:
{
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };
  };

  security.pam.services.hyprlock = { };

  xdg.portal = {
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
    ];
  };
}
