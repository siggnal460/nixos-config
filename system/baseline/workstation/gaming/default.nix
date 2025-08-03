{
  pkgs,
  lib,
  ...
}:
{
  imports = [ ../../../shared/gaming-tweaks.nix ];

  nixpkgs.config = {
    allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-run"
        "steam-original"
        "steam-unwrapped"
      ];
  };

  programs.steam.gamescopeSession.enable = true;

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
      flatpak override --filesystem=/srv/games com.valvesoftware.Steam && \
    	  echo "Giving Steam access to /srv/games"
    	flatpak override --env=LSFG_CONFIG=/home/<user>/.config/lsfg-vk/conf.toml com.valvesoftware.Steam && \
    	  echo "Setting LSFG_CONFIG for Steam"
    	flatpak override --filesystem=/home/aaron/.config/lsfg-vk:rw com.valvesoftware.Steam && \
    	  echo "Giving Steam access to lsfg-vk configuration"
    '';
  };

  environment.systemPackages = with pkgs; [
    heroic
    obs-studio
    pcsx2
    phoronix-test-suite
  ];
}
