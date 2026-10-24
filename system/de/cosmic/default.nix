{ pkgs, ... }:
{
  #programs = {
  #  uwsm = {
  #    enable = true;
  #    waylandCompositors.cosmic = {
  #      prettyName = "COSMIC";
  #      comment = "System76's COSMIC Desktop Environment";
  #      binPath = "/run/current-system/sw/bin/cosmic-session";
  #    };
  #  };
  #};

  environment.sessionVariables = {
    XCURSOR_SIZE = "16";
    XDG_CURRENT_DESKTOP = "COSMIC";
  };

  services = {
    desktopManager.cosmic.enable = true;
    displayManager.cosmic-greeter.enable = true;
    system76-scheduler.enable = true; # improves performance?
  };

  xdg = {
    terminal-exec = {
      enable = true;
      settings.default = [ "org.wezfurlong.wezterm.desktop" ];
    };
  };

  environment = {
    systemPackages = [
      pkgs.wezterm
      pkgs.mpv
    ];
  };
}
