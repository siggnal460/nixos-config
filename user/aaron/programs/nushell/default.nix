{ lib, options, ... }:
{
  programs.nushell = {
    enable = true;
    shellAliases = {
      diff = "diff --color";
      la = "ls -la";
      nixos-generate-iso = "nix run github:nix-community/nixos-generators -- -c /tmp -f install-iso --flake";
      worknix = "cd /etc/nixos";
    };
    configFile.source = ./config/config.nu;
  }
  # Only present on home-manager-unstable; pin legacy behavior there since
  # home.stateVersion < 26.11 (stable home-manager doesn't have this option yet).
  // lib.optionalAttrs (options.programs.nushell ? loadSessionVariables) {
    loadSessionVariables = false;
  };
}
