{
  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
    settings = {
      position = "top-center";
      font_size = 36;
      fsr_steam_sharpness = 5;
      nis_steam_sharpness = 10;
      legacy_layout = 0;
      horizontal = true;
      gpu_stats = true;
      cpu_stats = true;
      ram = true;
      fps = true;
      frametime = 0;
      hud_no_margin = true;
      #table_columns=14;
      full = true;
      cpu_load_change = true;
      gpu_load_change = true;
    };
  };

  home.sessionVariables = {
    MANGOHUD_CONFIGFILE = "/home/aaron/.config/MangoHud/MangoHud.conf";
  };
  systemd.user.sessionVariables = {
    MANGOHUD_CONFIGFILE = "/home/aaron/.config/MangoHud/MangoHus.conf";
  };
}
