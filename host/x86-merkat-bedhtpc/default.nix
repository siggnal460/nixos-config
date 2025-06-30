{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../system/shared/plymouth-tv.nix
  ];

  networking = {
    hostName = "x86-merkat-bedhtpc";
  };

  home-manager.users.aaron.wayland.windowManager.sway.config.output.HDMI-A-2.mode = "3840x2160@60Hz";
}
