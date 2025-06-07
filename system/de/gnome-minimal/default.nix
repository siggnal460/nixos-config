{ pkgs, ... }:
{
	services = {
    xserver.enable = true;
    displayManager.gdm = {
      enable = true;
      autoSuspend = false;
    };
    desktopManager.gnome.enable = true;
  };

  environment.gnome.excludePackages = (
    with pkgs;
    [
      atomix
      cheese
      epiphany
      evince
      geary
      gedit
      gnome-characters
      gnome-music
      gnome-photos
      gnome-terminal
      gnome-tour
      hitori
      iagno
      tali
      totem
    ]
  );
}
