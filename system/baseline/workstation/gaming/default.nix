{
  pkgs,
  lib,
  ...
}:
{
  imports = [ ../../../shared/gaming-tweaks.nix ];

  nixpkgs.config = {
    allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-run"
        "steam-original"
        "steam-unwrapped"
      ];
  };

  programs.steam.gamescopeSession.enable = true;

  environment.systemPackages = with pkgs; [
    heroic
    obs-studio
    pcsx2
    phoronix-test-suite
  ];
}
