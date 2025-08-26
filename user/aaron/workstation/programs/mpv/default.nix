{
  # jellyfinmediaplayer can use an mpv.conf as well
	systemd.user.tmpfiles.rules = [
	  "L+ %h/.config/mpv/mpv.conf - - - - %h/.local/share/jellyfinmediaplayer/mpv.conf"
	];

  programs.mpv = {
    enable = true;
    defaultProfiles = [ "gpu-hq" ];
    config = {
      hwdec = "auto";
      profile = "gpu-hq";
      vo = "gpu-next";
			vf = "scale=height=ih*10:sws_flags=neighbor,scale=height=720:sws_flags=bicubic";
			gpu-api = "vulkan";
      gpu-context = "waylandvk";
      loop-file = "inf";
      border = "no";
      save-position-on-quit = "yes";
    };
  };
}
