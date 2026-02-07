{
  inputs,
  pkgs,
  lib,
  ...
}:
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
  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
    inputs.nix-gaming.nixosModules.platformOptimizations
    inputs.lsfg-vk-flake.nixosModules.default
    ./nfs-client.nix
  ];

  systemd.tmpfiles.rules = [
    "L+ /srv/games - - - - /nfs/games" # Retroarch Steam can only access /srv for some reason (??)
  ];

  fileSystems = {
    "/nfs/games" = {
      device = lib.mkForce "x86-rakmnt-mediaserver:/export/games";
      fsType = lib.mkForce "nfs4";
      options = mountOptions;
    };
  };

  services = {
    pipewire.lowLatency = {
      enable = true;
      quantum = 64;
      rate = 48000;
    };
    lsfg-vk = {
      enable = true;
      ui.enable = true;
    };
  };

  hardware.steam-hardware.enable = true;

  programs.steam.platformOptimizations.enable = true;

  environment.systemPackages = [
    pkgs.protonup-rs
  ];
}
