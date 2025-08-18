{
  programs = {
    waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ "hyprland/window" ];
          modules-right = [
            "mpris"
            "cpu"
            "memory"
            "temperature"
            "clock"
          ];
          "hyprland/workspaces" = {
            format = "{icon}";
            format-icons = {
              "General" = "󰻀";
              "Gaming" = "";
              "Chat" = "󰭹";
              "Blender" = "";
              "Development" = "";
              "Jellyfin" = "󰼂";
            };
          };
          "hyprland/window" = {
            max-length = 75;
          };
          "mpris" = {
            format = " {dynamic}  ";
            format-paused = " {dynamic}  ";
            dynamic-len = 40;
          };
          "cpu" = {
            format = " {}%  ";
          };
          "memory" = {
            format = " {}%  ";
          };
          "temperature" = {
            format = " {temperatureC}°C  ";
            format-critical = " {temperatureC}°C  ";
          };
          "clock" = {
            format = " {:%a, %d %b  %H:%M}";
            tooltip-format = "{calendar}";
          };
        };
      };
    };
  };
}
