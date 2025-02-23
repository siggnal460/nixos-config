{ lib, ... }:
with lib;
{
  options.beszel-agent = {
    publicKey = mkOption {
      type = types.str;
      default = "";
      description = "Public SSH key for the Beszel client";
    };
  };
}
