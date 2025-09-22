{ pkgs, ... }:
let
  latestSourceURL = name: "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";
in
{
  home-manager.users.aaron = {
    imports = [ ../workstation/programs/wezterm ];

    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 96;
    };

    stylix.targets.librewolf.profileNames = [ "yt-kiosk" ];
    stylix.targets.swaylock.useWallpaper = false;

    xdg.desktopEntries = {
      steam = {
        name = "Steam";
        noDisplay = true;
      };
      nvim = {
        name = "Neovim wrapper";
        noDisplay = true;
      };
      cups = {
        name = "Manage Printing";
        noDisplay = true;
      };
      gammastep-indicator = {
        name = "Gammastep Indicator";
        noDisplay = true;
      };
      kvantummanager = {
        name = "Kvantum Manager";
        noDisplay = true;
      };
      librewolf = {
        name = "LibreWolf";
        noDisplay = true;
      };
      rofi = {
        name = "Rofi";
        noDisplay = true;
      };
      rofi-theme-selector = {
        name = "Rofi Theme Selector";
        noDisplay = true;
      };
      blueman-adapters = {
        name = "Bluetooth Adapters";
        noDisplay = true;
      };
      blueman-manager = {
        name = "Bluetooth Manager";
        noDisplay = true;
      };
      "gay.pancake.lsfg-vk-ui" = {
        name = "lsfg-vk Configuration Window";
        noDisplay = true;
      };
      nixos-manual = {
        name = "NixOS Manual";
        noDisplay = true;
      };
      qt5ct = {
        name = "Qt5 Settings";
        noDisplay = true;
      };
      qt6ct = {
        name = "Qt6 Settings";
        noDisplay = true;
      };
      uuctl = {
        name = "User unit manager";
        noDisplay = true;
      };
      xdg-desktop-portal-gtk = {
        name = "Portal";
        noDisplay = true;
      };
      wezterm = {
        name = "WezTerm";
        noDisplay = true;
      };
      youtube = {
        name = "YouTube";
        genericName = "LibreWolf YouTube Kiosk";
        exec = "librewolf --profile /home/aaron/.librewolf/yt-kiosk --kiosk https://www.youtube.com %U";
        terminal = false;
        icon = ../../../images/icons/arrow.svg;
        categories = [
          "Application"
          "WebBrowser"
          "Video"
        ];
      };
      steam-bpm = {
        name = "Steam BPM";
        genericName = "Big Picture Mode";
        exec = "steam -start steam://open/bigpicture %U";
        terminal = false;
        icon = ../../../images/icons/steam.svg;
        categories = [
          "Application"
          "Game"
        ];
      };
    };

    programs = {
      rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
        extraConfig = {
          show-icons = true;
          icon-theme = "Papirus-Dark";
        };
      };
      librewolf = {
        enable = true;
        policies = {
          Cookies.Allow = [ "https://www.youtube.com" ];
          DisplayBookmarksToolbar = "never";

          ExtensionSettings = {
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

          Preferences = {
            "browser.tabs.inTitlebar" = false;
            "kiosk.mode" = true;
            "kiosk.url" = "https://www.youtube.com";
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
      gammastep.enable = true;
      swayidle.enable = true;
    };

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = false;
      settings = {
        "$terminal" = "wezterm";
        "$menu" = "rofi -show drun";
        "$switcher" = "rofi -show window";
        "$mainMod" = "CTRL";

        autogenerated = 0;

        bind = [
          "$mainMod, Q, exec, $terminal"
          "$mainMod, C, killactive"
          "$mainMod, M, exit"
          "$mainMod, F, fullscreen, 0"
          "$mainMod, R, exec, $menu"
          "$mainMod, S, exec, $switcher"
          "$mainMod CTRL, right, workspace, m+1"
          "$mainMod CTRL, left, workspace, m-1"
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
        ];

        env = [
          "GDK_SCALE,3"
          "XCURSOR_SIZE,64"
          "HYPRCURSOR_SIZE,96"
          "XDG_SESSION_TYPE,wayland"
        ];

        windowrule = [
          "fullscreen, class:.*"
          "workspace 1, class:.*"
          "workspace 2, class:^(Kodi)(.*)$"
          "workspace 3, class:^(steam)(.*)$"
          "workspace 4, class:^(librewolf)(.*)$"
        ];

        xwayland = {
          force_zero_scaling = true;
        };
      };
    };
  };
}
