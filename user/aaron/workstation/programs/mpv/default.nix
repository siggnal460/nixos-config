{
  programs.mpv = {
    enable = true;
    defaultProfiles = [ "gpu-hq" ];
    config = {
      hwdec = "auto-safe";
      profile = "gpu-hq";
      vo = "gpu";
      gpu-context = "wayland";
      loop-file = "inf";
      border = "no";
      save-position-on-quit = "yes";
    };
  };
}
