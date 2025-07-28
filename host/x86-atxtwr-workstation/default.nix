{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking = {
    hostName = "x86-atxtwr-workstation";
  };

  services.ratbagd.enable = true;

  fileSystems."/mnt/nvme1n1" = {
    device = "/dev/disk/by-uuid/5b778bef-b3af-4710-9d44-6424b693dc29";
    fsType = "ext4";
  };

  environment = {
    systemPackages = with pkgs; [
      system76-keyboard-configurator
      piper
    ];
  };

  systemd.services.flatpak-workstation-tweaks = { # this has a 175hz monitor
    wantedBy = [ "multi-user.target" ];
    after = [ "flatpak-gaming-tweaks.service" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak override --env=MANGOHUD_CONFIG=fps_limit=175 com.valvesoftware.Steam
    '';
  };
}
