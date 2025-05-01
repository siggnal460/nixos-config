{ pkgs, lib, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  stylix = {
    base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/nord.yaml";
  };

  networking = {
    hostName = "x86-laptop-galago";
    /*
      interfaces.enp36s0 = {
        useDHCP = false;
        ipv4.addresses = [{
          address = "10.2.0.1";
          prefixLength = 12;
        }];
      };
      interfaces.enp4s0u1u3u3 = {
        useDHCP = false;
        ipv4.addresses = [{
          address = "10.2.0.1";
          prefixLength = 12;
        }];
      };
      #priorities per network interface, lower is more preferred
      dhcpcd.extraConfig = ''
      interface enp36s0
      metric 1

      interface enp4s0u1u3u3
      metric 2

      interface wlp0s20f3
      metric 3
      '';
    */
  };

  /*
    This doesn't work I guess?
    home-manager.users.aaron = {
      wayland.windowManager.hyprland.extraConfig = ''
        monitor = eDP-1,1920x1080@144,1300x-1080,1.25
        monitor = DP-2,1920x1080@143.981,1920x0,1
        monitor = DP-7,1920x1080@143.981,0x0,1
        '';
    };
  */

  services.ratbagd.enable = true;

  environment = {
    systemPackages = with pkgs; [
      system76-keyboard-configurator
      piper
    ];
  };
}
