{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking = {
    hostName = "x86-atxtwr-workstation";
  };

  services.ratbagd.enable = true;

  environment = {
    systemPackages = with pkgs; [
      system76-keyboard-configurator
      piper
    ];
  };

  systemd.services.flatpak-host-tweaks = {
    wantedBy = [ "multi-user.target" ];
    requires = [ "flatpak-gaming-setup.service" ];
    path = [ pkgs.flatpak ];
    script = ''
            flatpak override --env=DXVK_FRAME_RATE=240 com.valvesoftware.Steam && \
      			  echo "Setting max framerate for DXVK"
    '';
  };
}
