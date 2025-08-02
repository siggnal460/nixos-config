{
  pkgs,
  ...
}:
let
  losslessDll = "/home/aaron/.steam/steam/SteamApps/common/Lossless Scaling/Lossless.dll";
in
{
  home-manager.users.aaron = {
    home.file."/.config/lsfg-vk/conf.toml" = {
      source = (pkgs.formats.toml { }).generate "lsfg-vk-configuration" {
        version = 1;
        global = {
          dll = losslessDll;
        };
        game = [
          {
            #for testing
            exe = "vkcube";
            multiplier = 4;
          }
          {
            # for use with "LSFG_PROCESS"
            exe = "lsfg2";
            multiplier = 2;
          }
          {
            # for use with "LSFG_PROCESS"
            exe = "lsfg3";
            multiplier = 3;
          }
          #{
          #{
          #  exe = "retroarch";
          #  multiplier = 2;
          #}
        ];
      };
    };
  };
}
