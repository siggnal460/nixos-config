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
    "x-systemd.device-timeout=2s"
    "x-systemd.mount-timeout=2s"
    "bg"
    "noauto"
    "nofail"
  ];
in
{
  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
    inputs.nix-gaming.nixosModules.platformOptimizations
    inputs.lsfg-vk-flake.nixosModules.default
    ./nfs-client.nix
  ];

  systemd.tmpfiles.rules = [
    "d /srv/games 0775 root games"
    "L+ /nfs/games - - - - /srv/games"
  ];

  users.groups = {
    games = {
      gid = 770;
    };
  };

  fileSystems = {
    "/srv/games" = {
      # Steam RetroArch's weird sanboxing make this the only place we can mount this unfortunately
      device = lib.mkForce "x86-rakmnt-mediaserver:/export/games";
      fsType = lib.mkForce "nfs4";
      options = mountOptions;
    };
  };

  # This shouldn't be necessary but the /srv/games mount tries to mount 1 second after network-online.target is reached and it fails for whatever reason. We want it automounted because RetroArch cannot initiate the mount.
  networking.networkmanager.dispatcherScripts = [
    {
      source = pkgs.writeText "upHook" ''
        #!/usr/bin/env ${pkgs.bash}/bin/bash

        echo "Starting /srv/games NetworkManager dispatcher script."

        success=0

        if [[ "$2" == "up" ]] && [[ "$DEVICE_IFACE" != "lo" ]]; then
          echo "Device $DEVICE_IFACE is up. Pinging x86-rakmnt-mediaserver before trying to mount /srv/games..."
          for (( i=1; i<=2; i++ )); do
            ${pkgs.toybox}/bin/ping -c 1 -W 2 x86-rakmnt-mediaserver > /dev/null 2>&1  

            if [ $? -eq 0 ]; then
              echo "Successfully pinged x86-rakmnt-mediaserver."
              success=1
              break
            else
              echo "Ping of x86-rakmnt-mediaserver failed. Retrying in 2 seconds..."
              sleep 2
            fi
          done

          if [ "$success" == 1 ]; then
            echo "Attempting to mount /srv/games..."
            mount /srv/games && echo "/srv/games mount successful."
          else
            echo "Two ping attempts on NFS server failed. Moving on."
          fi
        fi
      '';
      type = "basic";
    }
  ];

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
