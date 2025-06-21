{ pkgs, ... }:
{
  home-manager.users.aaron = {
    programs = {
      nushell.extraConfig = ''
        			  if not ("WAYLAND_DISPLAY" in $env) and ("XDG_VTNR" in $env) and ($env.XDG_VTNR == 1) {
        			      sway
        		    }
        			'';
      kodi = {
        enable = true;
        package = pkgs.kodi.withPackages (exts: [
          exts.jellyfin
          exts.sponsorblock
          exts.libretro
          exts.upnext
        ]);
        addonSettings = {
          "plugin.video.invidious" = {
            auto_instance = "false";
            instance_url = "http://x86-atxtwr-computeserver:3004";
          };
        };
      };
    };

    services.gammastep = {
      enable = true;
      dawnTime = "5:15";
      duskTime = "19:00-20:30";
      settings = {
        general = {
          adjustment-method = "wayland";
        };
      };
    };

    wayland.windowManager.sway = {
      enable = true;
      config = {
        assigns = {
          "0: kodi" = [ { class = "^kodi$"; } ];
        };
        bars = [ ];
        modifier = "Control";
        seat = {
          "*" = {
            hide_cursor = "100";
          };
        };
        startup = [
          {
            command = "kodi --fullscreen";
            always = true;
          }
        ];
        window = {
          border = 0;
          titlebar = false;
        };
      };
    };
  };
}
