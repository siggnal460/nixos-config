{
  stylix.targets.waybar.enable = false;
  programs = {
    waybar = {
      enable = true;
      style = ./style.css;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          margin-top = 12;
          margin-right = 12;
          margin-left = 12;
          margin-bottom = -8;
          spacing = 8;
          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ "hyprland/window" ];
          modules-right = [
            "mpris"
            "cpu"
            "memory"
            "temperature"
            "wireplumber"
            "clock"
          ];
          "hyprland/workspaces" = {
            format = "{icon}";
            persistent-workspaces = [
              "General"
            ];
            format-icons = {
              "General" = "󰻀";
              "Steam" = "";
              "Discord" = "";
              "Blender" = "";
              "Development" = "";
              "Jellyfin" = "󰼂";
              "Gamedev" = "󰊖";
              "default" = "";
              "empty" = "";
              "urgent" = "";
            };
          };
          "hyprland/window" = {
            max-length = 75;
          };
          "mpris" = {
            format = " {dynamic}";
            format-paused = " {dynamic}";
            dynamic-len = 60;
          };
          "cpu" = {
            format = " {}%";
          };
          "memory" = {
            format = " {}%";
          };
          "temperature" = {
            format = " {temperatureC}°C";
            format-critical = " {temperatureC}°C";
          };
          "wireplumber" = {
            format = "{icon} {volume}%";
            format-muted = "";
            format-icons = [
              ""
              ""
              ""
            ];
            on-click = "pavucontrol";
            scroll-step = 2.5;
          };
          "wireplumber#source" = {
            node-type = "Audio/Source";
            format = "󰍬 {volume}%";
            format-muted = "󰍭";
            on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          };
          "clock" = {
            format = " {:%a, %d %b %H:%M}";
            tooltip-format = "{calendar}";
          };
        };
      };
    };
  };
}
