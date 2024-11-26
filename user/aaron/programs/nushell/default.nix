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
  };
}
