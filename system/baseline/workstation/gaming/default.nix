{ pkgs, lib, ... }:
{
  imports = [
    ../../../shared/gaming-tweaks.nix
  ];

  nixpkgs.config = {
    allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-run"
        "steam-original"
        "steam-unwrapped"
        "discord"
      ];
  };

  environment.systemPackages = with pkgs; [
    (pkgs.discord.override {
      withVencord = true;
    })
    heroic
    obs-studio
    phoronix-test-suite
    xivlauncher
  ];
}
