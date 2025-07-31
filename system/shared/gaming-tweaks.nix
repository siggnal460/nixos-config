{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
let
  mountOptions = [
    "x-systemd.automount"
    "noauto"
    "x-systemd.idle-timeout=1800"
    "_netdev"
    "bg"
  ];
in
{
  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
    inputs.nix-gaming.nixosModules.platformOptimizations
    inputs.lsfg-vk-flake.nixosModules.default
    ./nfs-client.nix
  ];

  users.groups = {
    games = {
      gid = 770;
    };
  };

  systemd.tmpfiles.rules = [
    "d /nfs/games 0775 root games"
    "d /srv/system 0775 aaron users"
    "d /srv/roms 0775 aaron users"
  ];

  fileSystems = {
    "/nfs/games" = {
      device = lib.mkForce "x86-rakmnt-mediaserver:/export/games";
      fsType = lib.mkForce "nfs4";
      options = mountOptions;
    };
    "/srv/system" = {
      device = lib.mkForce "/nfs/games/bios";
      options = [ "bind" ];
    };
    "/srv/roms" = {
      # This location makes no sense for this, but RetroArch Steam has odd sandboxing so you need a bind mount somewhere and this is the only sensible place to put it
      device = lib.mkForce "/nfs/games/roms";
      options = [ "bind" ];
    };
  };

  services = {
    lsfg-vk = {
      enable = true;
      ui.enable = false;
    };
    pipewire.lowLatency = {
      enable = true;
      quantum = 64;
      rate = 48000;
    };
  };

  hardware.steam-hardware.enable = true;

  programs.steam.platformOptimizations.enable = true;

  systemd.services.flatpak-gaming-tweaks = lib.mkIf config.gappyland.jovian {
    wantedBy = [ "multi-user.target" ];
    after = [ "flatpak-install.service" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      flatpak install -y --noninteractive flathub com.valvesoftware.Steam//stable
      flatpak install -y --noninteractive flathub org.freedesktop.Platform.VulkanLayer.MangoHud//24.08
      flatpak install -y --noninteractive flathub dev.goats.xivlauncher
      flatpak override --env=MANGOHUD=1 com.valvesoftware.Steam
      flatpak override --env=ENABLE_LSFG=1 com.valvesoftware.Steam
      flatpak override --filesystem=/nfs/games com.valvesoftware.Steam 
    '';
  };
}
