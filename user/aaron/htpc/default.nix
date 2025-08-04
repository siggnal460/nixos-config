{ pkgs, config, ... }:
let
  modifier = "Control";
  latestSourceURL = name: "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";
in
{
  home-manager.users.aaron = {
    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 96;
    };

    stylix.targets.librewolf.profileNames = [ "yt-kiosk" ];
    stylix.targets.swaylock.useWallpaper = false;

    xdg.desktopEntries = {
      youtube = {
        name = "YouTube";
        genericName = "LibreWolf YouTube Kiosk";
        exec = "librewolf --profile /home/aaron/.librewolf/yt-kiosk --kiosk https://www.youtube.com %U";
        terminal = false;
        icon = ../../../images/icons/arrow.svg;
        categories = [
          "Application"
          "Network"
          "WebBrowser"
        ];
        mimeType = [
          "text/html"
          "text/xml"
        ];
      };
    };

    programs = {
      librewolf = {
        enable = true;
        policies = {
          Cookies.Allow = [ "https://www.youtube.com" ];

          Preferences = {
            "browser.tabs.inTitlebar" = false;
            "kiosk.mode" = true;
            "kiosk.url" = "https://www.youtube.com";
          };
          policies.ExtensionSettings = {
            "sponsorBlocker@ajay.app" = {
              default_area = "menupanel";
              install_url = latestSourceURL "sponsorblock";
              installation_mode = "force_installed";
              locked = true;
            };
            "cb-remover@search.mozilla.org" = {
              default_area = "menupanel";
              install_url = latestSourceURL "clickbait-remover-for-youtube";
              installation_mode = "force_installed";
              locked = true;
            };
            "uBlock0@raymondhill.net" = {
              default_area = "menupanel";
              install_url = latestSourceURL "ublock-origin";
              installation_mode = "force_installed";
              private_browsing = true;
              locked = true;
            };
          };
        };
      };

      swaylock = {
        enable = true;
        settings = {
          image = ../../../images/lockscreen/bus.jpg;
          indicator-radius = 100;
          indicator-thickness = 20;
          font-size = 96;
          show-failed-attempts = true;
        };
      };

      fuzzel.enable = true;

      nushell.extraConfig = ''
        if not ("WAYLAND_DISPLAY" in $env) and ("XDG_VTNR" in $env) and ($env.XDG_VTNR == 1) {
          sway
        }
      '';

      kodi = {
        enable = true;
        package = pkgs.kodi-wayland.withPackages (exts: [
          exts.jellyfin
          exts.sponsorblock
          exts.libretro
          exts.upnext
          exts.inputstream-adaptive
        ]);
        addonSettings = {
          "plugin.video.invidious" = {
            auto_instance = "false";
            instance_url = "http://x86-atxtwr-computeserver:3004";
          };
        };
      };
    };

    services = {
      gammastep = {
        enable = true;
        dawnTime = "5:15";
        duskTime = "19:00-20:30";
        settings = {
          general = {
            adjustment-method = "wayland";
          };
        };
      };

      swayidle = {
        enable = true;
        extraArgs = [ "-w" ];
        events = [
          {
            event = "before-sleep";
            command = "${pkgs.swaylock}/bin/swaylock -fF";
          }
        ];
        timeouts = [
          {
            timeout = 600; # 10min
            command = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
          }
          {
            timeout = 1200; # 20min
            command = "${pkgs.systemd}/bin/systemctl sleep";
          }
        ];
      };
    };

    wayland.windowManager.sway = {
      enable = true;
      config = {
        assigns = {
          "1: kodi" = [ { app_id = "kodi"; } ];
          "2: librewolf" = [ { app_id = "librewolf"; } ];
        };
        bars = [ ];
        defaultWorkspace = "1";
        focus.newWindow = "none";
        keybindings = {
          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+f" = "fuzzel";
        };
        modifier = "${modifier}";
        seat = {
          "*" = {
            hide_cursor = "2000"; # 2s
          };
        };
        startup = [
          {
            command = "kodi --fullscreen";
            always = true;
          }
          {
            command = "librewolf --profile ~/.librewolf/yt-kiosk --kiosk https://www.youtube.com ";
            always = true;
          }
        ];
        window = {
          border = 0;
          titlebar = false;
          commands = [
            {
              command = "fullscreen enable";
              criteria = {
                app_id = "librewolf";
              };
            }
          ];
        };
      };
    };
  };
}
