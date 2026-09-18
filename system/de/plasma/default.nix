{ pkgs, ... }:
{
  services = {
    desktopManager.plasma6.enable = true;
  };

  xdg.portal = {
    enable = true;
    # Use the new kdePackages scope instead of a top-level package
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
    xdgOpenUsePortal = true;
  };

  xdg.portal.config = {
    common = {
      # Specify exactly what KDE should handle, leaving other things alone
      "org.freedesktop.impl.portal.FileChooser" = "kde";
      "org.freedesktop.impl.portal.Screenshot" = "kde";
    };
  };
}
