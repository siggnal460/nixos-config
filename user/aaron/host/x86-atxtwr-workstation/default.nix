{
  pkgs,
  config,
  ...
}:
let
  losslessDll = "/home/aaron/.var/app/com.valvesoftware.Steam/.steam/steam/steamapps/common/Lossless Scaling/Lossless.dll";
  nvidia_env =
    if (builtins.elem "nvidia" config.boot.initrd.kernelModules) then
      [
        "LIBVA_DRIVER_NAME,nvidia"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "NVD_BACKEND,direct"
      ]
    else
      [ ];
in
{
  home-manager.users.aaron = {
    wayland.windowManager.hyprland.settings = {
      monitor = [
        "DP-1, 3440x1440@240.08501, 0x0, 1"
        "DP-2, 2560x1440@239.97, 440x-1440, 1"
      ];
      env = [ ] ++ nvidia_env;
    };

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
            exe = "re2";
            multiplier = 2;
            hdr_mode = 1;
          }
          {
            exe = "mpv";
            multiplier = 2;
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
          {
            exe = "retroarch";
            multiplier = 3;
          }
        ];
      };
    };
  };
}
