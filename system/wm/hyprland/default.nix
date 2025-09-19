{ pkgs, ... }:
{
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };
  };

  services.xserver.displayManager = {
    gdm = {
      enable = true;
      wayland = true;
    };
  };

  environment.systemPackages = [
    pkgs.grimblast
  ];
}
