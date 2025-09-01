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

  environment.systemPackages = [
    pkgs.grimblast
  ];
}
