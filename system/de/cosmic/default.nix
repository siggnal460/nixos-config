{ pkgs, ... }:
{
  programs = {
    uwsm = {
      enable = true;
      waylandCompositors.cosmic = {
        prettyName = "COSMIC";
        comment = "System76's COSMIC Desktop Environment";
        binPath = "/run/current-system/sw/bin/cosmic-session";
      };
    };
  };

  environment.sessionVariables = {
    XCURSOR_SIZE = "16";
  };

  services = {
    desktopManager.cosmic.enable = true;
    system76-scheduler.enable = true; # improves performance?
  };

  xdg.portal = {
    extraPortals = [
      pkgs.xdg-desktop-portal-cosmic
    ];
    config = {
      cosmic = {
        default = [
          "cosmic"
        ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "cosmic" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "cosmic" ];
      };
    };
  };

  environment = {
    systemPackages = [
      pkgs.wezterm
      pkgs.mpv
    ];
  };
}
