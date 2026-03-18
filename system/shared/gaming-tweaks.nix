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
    lsfg-vk = {
      enable = true;
      ui.enable = true;
    };
  };

  hardware.steam-hardware.enable = true;

  programs.steam.platformOptimizations.enable = true;

  systemd.services.flatpak-gaming-tweaks = {
    wantedBy = [ "multi-user.target" ];
    requires = [ "flatpak-install.service" ];
    path = [ pkgs.flatpak ];
    script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && \
      	  echo "Flathub remote added if it wasn't already"
        flatpak install -y --noninteractive --or-update flathub net.retrodeck.retrodeck//stable && \
      	  echo "Made sure Retrodeck was installed"
        flatpak override --filesystem=/srv/games net.retrodeck.retrodeck && \
      	  echo "Giving Rerodeck access to /srv/games"
    '';
  };

  environment.systemPackages = with pkgs; [
    dolphin-emu
    pcsx2
    protonplus
  ];
}
