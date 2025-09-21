{ ... }:
{
  home-manager.users.aaron = {
    home.sessionVariables = {
      GDK_SCALE = 2;
    };
    wayland.windowManager.hyprland.settings = {
      monitor = "HDMI-A-2, 3840x2160@60, 0x0, 3, bitdepth, 10, cm, hdr";
    };
  };
}
