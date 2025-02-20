{
  programs.mpv = {
    enable = true;
    defaultProfiles = [ "gpu-hq" ];
    config = {
      profile = "gpu-hq";
      glsl-shader = "~~/FSRCNNX_x2_8-0-4-1.glsl";
      loop-file = "inf";
      border = "no";
      save-position-on-quit = "yes";
    };
  };
}
