{
  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
  };

  home.sessionVariables = {
    MANGOHUD_CONFIGFILE = "/home/aaron/.config/MangoHud/MangoHud.conf";
  };
  systemd.user.sessionVariables = {
    MANGOHUD_CONFIGFILE = "/home/aaron/.config/MangoHud/MangoHus.conf";
  };

  home.file."/.config/MangoHud" = {
    source = ./config;
    recursive = true;
  };
}
