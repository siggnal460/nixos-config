let
  latestSourceURL = name: "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";
in
{ config, pkgs, ... }:
{
  programs.librewolf = {
    enable = true;

    policies = {
      DisableAccounts = true;
      DisableFirefoxAccounts = true;
      DisableFirefoxScreenshots = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisplayBookmarksToolbar = "never";

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
    };

    profiles = {
      ${config.home.username} = {
        id = 0;
        name = "${config.home.username}";
        isDefault = true;
        search = {
          force = true;
          default = "PrivateSearch";
          engines = {
            "PrivateSearch" = {
              urls = [
                {
                  template = "https://privatesearch.app/search?q={searchTerms}";
                }
              ];
              iconUpdateURL = "https://privatesearch.app/static/themes/simple/img/favicon.svg";
              definedAliases = [ "@privatesearch" ];
            };

            "NixOS Options" = {
              urls = [
                {
                  template = "https://search.nixos.org/options?query={searchTerms}";
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@nixos" ];
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
              iconUpdateURL = "https://www.openstreetmap.org/favicon.ico";
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
      "{4520dc08-80f4-4b2e-982a-c17af42e5e4d}" = {
        default_area = "menupanel";
        install_url = latestSourceURL "tokyo-night-milav/";
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
