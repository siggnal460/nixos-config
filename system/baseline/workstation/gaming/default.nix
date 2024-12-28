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

  environment.systemPackages = with pkgs; [
    heroic
    obs-studio
    phoronix-test-suite
  ];
}
