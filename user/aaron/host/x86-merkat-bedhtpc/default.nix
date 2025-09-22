{ pkgs, ... }:
{
  home-manager.users.aaron = {
    wayland.windowManager.hyprland.settings = {
      monitor = "HDMI-A-2, 3840x2160@60, 0x0, 3, bitdepth, 10, cm, hdr";

      services.swayidle = {
        extraArgs = [ "-w" ];
        events = [
          {
            event = "before-sleep";
            command = "${pkgs.swaylock}/bin/swaylock -fF";
          }
        ];
        timeouts = [
          {
            timeout = 600; # 10min
            command = "${pkgs.swaylock}/bin/swaylock -f -c 000000"; # Change color to black
          }
          {
            timeout = 1200; # 20min
            command = "${pkgs.systemd}/bin/systemctl sleep";
          }
        ];
      };
    };
  };
}
