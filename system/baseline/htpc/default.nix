{ lib, pkgs, ... }:
{
  imports = [
    ../../shared/plymouth.nix
    ../../shared/quietboot.nix
    ../../shared/pipewire.nix
    ../../shared/bluetooth.nix
    ../../shared/remotely-managed.nix
  ];

  environment.sessionVariables = {
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

  services.xserver.displayManager = {
    gdm = {
      enable = true;
      wayland = true;
    };
  };

	environment.systemPackages = [
	  pkgs.kodiPackages.inputstream-adaptive
	];
}
