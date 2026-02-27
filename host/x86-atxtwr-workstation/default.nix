{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking = {
    hostName = "x86-atxtwr-workstation";
  };

  services.ratbagd.enable = true;

  #fileSystems."/mnt/nvme1n1" = {
  #  device = "/dev/disk/by-uuid/5b778bef-b3af-4710-9d44-6424b693dc29";
  #  fsType = "ext4";
  #};

  environment = {
    systemPackages = with pkgs; [
      system76-keyboard-configurator
      piper
    ];
  };

  systemd.services.flatpak-host-tweaks = {
    # this has a 175hz monitor
    wantedBy = [ "multi-user.target" ];
    requires = [ "flatpak-gaming-setup.service" ];
    path = [ pkgs.flatpak ];
    script = ''
            flatpak override --env=DXVK_FRAME_RATE=175 com.valvesoftware.Steam && \
      			  echo "Setting max framerate for DXVK"
    '';
  };
}
