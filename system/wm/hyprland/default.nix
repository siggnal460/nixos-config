{ pkgs, ... }:
{
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };
  };

  services = {
    displayManager.cosmic-greeter.enable = true;
  };

  environment.systemPackages = [
    pkgs.grimblast
    pkgs.pavucontrol
  ];
}
