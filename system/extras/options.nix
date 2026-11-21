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

    users.primaryUsers = lib.mkOption {
      type = with lib.types; listOf str;
      default = builtins.attrNames (lib.filterAttrs (_: u: u.isNormalUser or false) config.users.users);
      example = [ "aaron" ];
      description = ''
        The primary, fully-managed user(s) of this system (i.e. those with a
        profile under /user). Defaults to the normal users actually declared
        on this host. System modules that need to reference a concrete user
        (a systemd service's User, a session owner, a per-user directory
        owner) should read from this instead of hardcoding a username.
      '';
    };
  };

  config = {
    nixpkgs.config.allowUnfreePredicate =
      pkg: builtins.elem (lib.getName pkg) config.nixpkgs.allowUnfreePackages;
  };
}
