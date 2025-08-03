{
  pkgs,
  inputs,
  lib,
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
    pipewire.lowLatency = {
      enable = true;
      quantum = 64;
      rate = 48000;
    };
  };

  hardware.steam-hardware.enable = true;

  programs.steam.platformOptimizations.enable = true;
}
