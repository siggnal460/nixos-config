let
  latestSourceURL = name: "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";
in
{ config, pkgs, ... }:
{
  stylix.targets.librewolf.profileNames = [ "aaron" ];

  programs.librewolf = {
    enable = true;

    policies = {
      Authentication = true;
      DisableAccounts = true;
      DisableFirefoxAccounts = true;
      DisableFirefoxScreenshots = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisplayBookmarksToolbar = "newtab";

      EnableTrackingProtection = {
        Cryptomining = true;
        Fingerprinting = true;
        Locked = true;
        Value = true;
      };

      Homepage.URL = "https://gappyland.org";
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";

      Preferences = {
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.system.showSponsored" = false;
        "browser.newtabpage.pinned" = "";
        "browser.topsites.contile.enabled" = false;
      };

      Cookies.Allow = [
        "auth.gappyland.org"
        "media.gappyland.org"
        "requests.gappyland.org"
        "x86-rakmnt-mediaserver"
        "x86-rakmnt-mediaserver:6767"
        "x86-rakmnt-mediaserver:8188"
        "x86-rakmnt-mediaserver:7860"
        "x86-rakmnt-mediaserver:9696"
        "x86-rakmnt-mediaserver:7878"
        "x86-rakmnt-mediaserver:8787"
        "x86-rakmnt-mediaserver:4000"
        "x86-rakmnt-mediaserver:8989"
        "x86-rakmnt-mediaserver:8988"
        "x86-rakmnt-mediaserver:9091"
      ];
    };

    profiles = {
      ${config.home.username} = {
        id = 0;
        name = "${config.home.username}";
        isDefault = true;
        bookmarks = {
          force = true;
          settings = [
            {
              name = "Amazon";
              url = "https://amazon.com";
            }
            {
              name = "Local Servers";
              toolbar = true;
              bookmarks = [
                {
                  name = "Beszel";
                  url = "https://x86-rakmnt-mediaserver:6767";
                }
                {
                  name = "ComfyUI";
                  url = "https://x86-atxtwr-computeserver:8188";
                }
                {
                  name = "FluxGym";
                  url = "https://x86-atxtwr-computeserver:7860";
                }
                {
                  name = "Nextcloud";
                  url = "https://x86-rakmnt-mediaserver";
                }
                {
                  name = "Prowlarr";
                  url = "https://x86-rakmnt-mediaserver:9696";
                }
                {
                  name = "Radarr";
                  url = "https://x86-rakmnt-mediaserver:7878";
                }
                {
                  name = "Readarr";
                  url = "https://x86-rakmnt-mediaserver:8787";
                }
                {
                  name = "SillyTavern";
                  url = "https://x86-atxtwr-computeserver:4000";
                }
                {
                  name = "Sonarr";
                  url = "https://x86-rakmnt-mediaserver:8989";
                }
                {
                  name = "Sonarr-Anime";
                  url = "https://x86-rakmnt-mediaserver:8988";
                }
                {
                  name = "Transmission";
                  url = "https://x86-rakmnt-mediaserver:9091";
                }
              ];
            }
          ];
        };

        search = {
          force = true;
          default = "duckduckgo";
          engines = {
            "NixOS Options" = {
              urls = [
                {
                  template = "https://search.nixos.org/options?query={searchTerms}";
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@nix" ];
            };

            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages?query={searchTerms}";
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@nixpkgs" ];
            };

            "Home Manager" = {
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@hm" ];
              url = [
                {
                  template = "https://mipmip.github.io/home-manager-option-search/";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };

            "OpenStreetMap" = {
              urls = [
                {
                  template = "https://www.openstreetmap.org/search?query={searchTerms}";
                }
              ];
              icon = "https://www.openstreetmap.org/favicon.ico";
              definedAliases = [
                "@openstreetmap"
                "@osm"
              ];
            };
          };
        };
      };
    };

    policies.ExtensionSettings = {
      "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
        default_area = "menupanel";
        install_url = latestSourceURL "bitwarden-password-manager";
        installation_mode = "force_installed";
      };
      "addon@darkreader.org" = {
        default_area = "menupanel";
        install_url = latestSourceURL "darkreader";
        installation_mode = "force_installed";
      };
      "sponsorBlocker@ajay.app" = {
        default_area = "menupanel";
        install_url = latestSourceURL "sponsorblock";
        installation_mode = "force_installed";
      };
      "cb-remover@search.mozilla.org" = {
        default_area = "menupanel";
        install_url = latestSourceURL "clickbait-remover-for-youtube";
        installation_mode = "force_installed";
      };
      "uBlock0@raymondhill.net" = {
        default_area = "menupanel";
        install_url = latestSourceURL "ublock-origin";
        installation_mode = "force_installed";
      };
      "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
        default_area = "menupanel";
        install_url = latestSourceURL "vimium-ff";
        installation_mode = "force_installed";
      };
      "leechblockng@proginosko.com" = {
        default_area = "menupanel";
        install_url = latestSourceURL "leechblock-ng";
        installation_mode = "force_installed";
      };
    };
  };
}
