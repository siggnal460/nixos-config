{ pkgs, lib, ... }:
let
  mountOptions = [
    "x-systemd.automount"
    "x-systemd.device-timeout=2s"
    "x-systemd.mount-timeout=2s"
    "x-systemd.idle-timeout=600" # 10min
    "bg"
    "noauto"
    "nofail"
  ];
in
{
  imports = [ ./hardware-configuration.nix ];

  networking = {
    hostName = "x86-atxtwr-workstation";
  };

  systemd = {
    tmpfiles.rules = [
      "d /nfs/media 0770 root media"
    ];
  };

  fileSystems = {
    "/nfs/media" = {
      device = lib.mkForce "x86-rakmnt-mediaserver:/export/media";
      fsType = lib.mkForce "nfs4";
      options = mountOptions;
    };
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
    wantedBy = [ "multi-user.target" ];
    requires = [ "flatpak-gaming-setup.service" ];
    path = [ pkgs.flatpak ];
    script = ''
            flatpak override --env=DXVK_FRAME_RATE=240 com.valvesoftware.Steam && \
      			  echo "Setting max framerate for DXVK"
    '';
  };
}
