{ lib, config, ... }:
{
  options = {
    gappyland = {
      jovian = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "If the machine uses the Steam from Jovian (as opposed to flatpak Steam) as it's primary Steam interface. Determines how certain files are symlinked.";
      };
    };
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
