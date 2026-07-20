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
    ./nfs-client.nix
  ];

  systemd.tmpfiles.rules = [
    "L+ /nfs/games - - - - /srv/games" # Retroarch Steam can only access /srv for some reason (??)
  ];

  fileSystems = {
    "/srv/games" = {
      device = lib.mkForce "x86-rakmnt-mediaserver:/export/games";
      fsType = lib.mkForce "nfs4";
      options = mountOptions;
    };
  };

  services = {
    #pipewire.lowLatency = {
    #  enable = true;
    #  quantum = 64;
    #  rate = 48000;
    #};
  };

  hardware.steam-hardware.enable = true;

  programs.steam.platformOptimizations.enable = true;

  nixpkgs.config = {
    allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "steam-run"
        "steam-unwrapped"
      ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    dolphin-emu
    pcsx2
    protonplus
    retroarch-free
    steam-rom-manager
    steam-run
    lsfg-vk
    lsfg-vk-ui
  ];
}
