{ pkgs, ... }:
{
  imports = [
    ../../shared/plymouth-tv.nix
    ../../shared/pipewire.nix
    ../../shared/bluetooth.nix
    ../../shared/remotely-managed.nix
  ];

  systemd.services.rebuild.environment = {
    NIGHTLY_REFRESH = "poweroff-always";
  };

  networking.networkmanager.enable = true;

  programs.sway.enable = true;

  services.displayManager.defaultSession = "sway";

  environment.systemPackages = with pkgs; [
    kodiPackages.inputstream-adaptive
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
  ];
}
