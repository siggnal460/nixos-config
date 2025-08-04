{ lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "x86-merkat-bedhtpc";
  };

  programs.dconf.profiles.gdm.databases = [
    {
      settings."org/gnome/desktop/interface".scaling-factor = lib.gvariant.mkUint32 3;
    }
  ];

  home-manager.users.aaron.wayland.windowManager.sway.config.output.HDMI-A-2 = {
    scale = "3";
    mode = "3840x2160@60Hz";
  };
}
