{ lib, pkgs, ... }:
let
  sddmTheme = import ./sddm-theme.nix { inherit pkgs; };
in
{
  imports = [
    ../../shared/plymouth-tv.nix
    ../../shared/pipewire.nix
    ../../shared/bluetooth.nix
    ../../shared/remotely-managed.nix
  ];

  systemd.services.rebuild.environment = {
    NIGHTLY_REFRESH = "always-poweroff";
  };

  nixpkgs.config = {
    allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "steam-unwrapped"
      ];
  };

  networking.networkmanager.enable = true;

  hardware = {
    steam-hardware.enable = true;
    graphics.enable = true;
  };

  programs.sway.enable = true;

  services.displayManager.defaultSession = "sway";

  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
			enableHidpi = true;
			theme = "${sddmTheme}";
    };
  };

  environment.systemPackages = with pkgs; [
    kodiPackages.inputstream-adaptive
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
  ];
}
