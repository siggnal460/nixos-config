{ lib, config, ... }:
{
  options = with lib; {
    beszel-agent = {
      publicKey = mkOption {
        type = types.str;
        default = "";
        description = "Public SSH key for the Beszel client";
      };
    };
    nixpkgs.allowUnfreePackages = mkOption {
      type = with types; listOf str;
      default = [ ];
      example = [
        "steam"
        "steam-original"
      ];
    };
  };

  config = {
    nixpkgs.config.allowUnfreePredicate =
      pkg: builtins.elem (lib.getName pkg) config.nixpkgs.allowUnfreePackages;
  };
}
