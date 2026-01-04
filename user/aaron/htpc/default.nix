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
  };
}
