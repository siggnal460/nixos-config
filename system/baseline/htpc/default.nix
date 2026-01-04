{ pkgs, ... }:
{
  imports = [
    ../../de/cosmic
    ../../shared/gaming-tweaks.nix
    ../../shared/plymouth-quiet.nix
    ../../shared/pipewire.nix
    ../../shared/bluetooth.nix
    ../../shared/remotely-managed.nix
    ../../shared/cosmic-greeter.nix
  ];

  nixpkgs.allowUnfreePackages = [
    "steam"
    "steam-unwrapped"
  ];

  systemd.services.rebuild.environment = {
    NIGHTLY_REFRESH = "poweroff-always";
  };

  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    kodiPackages.inputstream-adaptive
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
    jellyfin-media-player
  ];

  programs.steam = {
    enable = true;
    extest.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    gamescopeSession.enable = true;
  };
}
