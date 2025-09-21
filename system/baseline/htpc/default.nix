{ pkgs, ... }:
{
  imports = [
    ../../wm/hyprland
    ../../shared/gaming-tweaks.nix
    ../../shared/plymouth-quiet.nix
    ../../shared/pipewire.nix
    ../../shared/bluetooth.nix
    ../../shared/remotely-managed.nix
  ];

  nixpkgs.allowUnfreePackages = [
    "steam"
    "steam-unwrapped"
  ];

  systemd.services.rebuild.environment = {
    NIGHTLY_REFRESH = "poweroff-always";
  };

  networking.networkmanager.enable = true;

  services.xserver.displayManager = {
		gdm = {
			enable = true;
			wayland = true;
		};
    defaultSession = "hyprland-uwsm";
  };

  environment.systemPackages = with pkgs; [
    wezterm
    kodiPackages.inputstream-adaptive
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
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
