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
      enable = lib.mkIf (config.jovian.steam.enable) true;
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

  systemd.services.flatpak-gaming-setup = lib.mkIf (!config.jovian.steam.enable) {
    wantedBy = [ "multi-user.target" ];
    requires = [ "flatpak-install.service" ];
    path = [ pkgs.flatpak ];
    script = ''
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && \
      			  echo "Flathub remote added if it wasn't already"
            flatpak install -y --noninteractive --or-update flathub com.valvesoftware.Steam//stable && \
      			  echo "Made sure Steam flatpak stable was installed"
            flatpak install -y --noninteractive --or-update flathub org.freedesktop.Platform.VulkanLayer.MangoHud//24.08 && \
      			  echo "Made sure MangoHud 24.08 was installed"
            flatpak install -y --noninteractive --or-update flathub dev.goats.xivlauncher && \
      			  echo "Made sure XIVLauncher was installed"
      			mkdir -p /opt/lsfg-vk-flatpak && \
      			  echo "Made sure /opt/lsfg-vk-flatpak directory exists"
      			${pkgs.wget}/bin/wget -nc -P /opt/lsfg-vk-flatpak https://github.com/PancakeTAS/lsfg-vk/releases/download/v1.0.0/org.freedesktop.Platform.VulkanLayer.lsfg_vk_24.08.flatpak && \
      			  echo "Made sure lsfg-vk-flatpak 24.08 was downloaded"
      			flatpak install -y --or-update /opt/lsfg-vk-flatpak/org.freedesktop.Platform.VulkanLayer.lsfg_vk_24.08.flatpak && \
      			  echo "Made sure lsfg-vk 24.08 for flatpak was installed"
            flatpak override --env=MANGOHUD=1 com.valvesoftware.Steam && \
      			  echo "Setting MANGOHUD variable for Steam"
            flatpak override --filesystem=/nfs/games com.valvesoftware.Steam && \
      			  echo "Giving Steam access to /nfs/games"
      			flatpak override --user --env=LSFG_CONFIG=/home/<user>/.config/lsfg-vk/conf.toml com.valvesoftware.Steam && \
      			  echo "Setting LSFG_CONFIG for Steam"
      			flatpak override --filesystem=/home/aaron/.config/lsfg-vk:rw com.valvesoftware.Steam && \
      			  echo "Giving Steam access to lsfg-vk configuration"
    '';
  };
}
