{ lib, config, ... }:
{
  options = {
    nixpkgs.allowUnfreePackages = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      example = [
        "steam"
        "steam-original"
      ];
      description = "A simple wrapper that allows declaring unfree packages to be easier.";
    };
  };

  config = {
    nixpkgs.config.allowUnfreePredicate =
      pkg: builtins.elem (lib.getName pkg) config.nixpkgs.allowUnfreePackages;
  };
}
