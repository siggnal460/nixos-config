{
  pkgs,
  config,
  inputs,
  ...
}:
let
  background = pkgs.fetchurl {
    name = "xVWaGv3.jpeg";
    url = "https://i.imgur.com/xVWaGv3.jpeg";
    hash = "sha256-0G+o36zUJas1ZZ1L5TiQNrjxS8nVAoHCwRlA9gsUEyY=";
  };
  logo = builtins.path {
    path = "${inputs.self}/images/icons/menacing.png";
    name = "homepage-logo";
  };
  icon = builtins.path {
    path = "${inputs.self}/images/icons/menacing.ico";
    name = "homepage-icon";
  };
  package = pkgs.homepage-dashboard.overrideAttrs (oldAttrs: {
    postInstall = ''
      mkdir -p $out/share/homepage/public/images
      ln -s ${background} $out/share/homepage/public/images/background.jpeg
      ln -s ${icon} $out/share/homepage/public/images/favicon.jpeg
      ln -s ${logo} $out/share/homepage/public/images/logo.jpeg
    '';
  });
in
{
  services.homepage-dashboard = {
    enable = true;
    package = package;
    openFirewall = true;
    environmentFile = config.sops.secrets."homepage/env".path;

    settings = {
      title = "Gappyland";
      description = "Gappy Makes Me Happy";
      hideVersion = true;
      theme = "dark";
      background = {
        image = "/images/background.jpeg";
        blur = "sm";
        saturate = "50";
        brightness = "50";
        opacity = "50";
      };
      favicon = "/images/favicon.ico";
    };

    services = [
      {
        Nextcloud = [
          {
            Dashboard = {
              icon = "nextcloud.svg";
              href = "https://nextcloud.gappyland.org/apps/dashboard";
              target = "_self";
            };
          }
          {
            Calendar = {
              icon = "nextcloud-calendar.svg";
              href = "https://nextcloud.gappyland.org/apps/calendar";
              target = "_self";
            };
          }
          {
            Contacts = {
              icon = "nextcloud-contacts.svg";
              href = "https://nextcloud.gappyland.org/apps/contacts";
              target = "_self";
            };
          }
          {
            Files = {
              icon = "nextcloud-files.svg";
              href = "https://nextcloud.gappyland.org/apps/files";
              target = "_self";
            };
          }
          {
            News = {
              icon = "nextcloud-news.svg";
              href = "https://nextcloud.gappyland.org/apps/news";
              target = "_self";
            };
          }
          {
            Notes = {
              icon = "nextcloud-notes.svg";
              href = "https://nextcloud.gappyland.org/apps/notes";
              target = "_self";
            };
          }
          {
            Tasks = {
              icon = "nextcloud-tasks.svg";
              href = "https://nextcloud.gappyland.org/apps/tasks";
              target = "_self";
            };
          }
        ];
      }

      {
        Media = [
          {
            Gaseous = {
              icon = "emulatorjs.svg";
            };
          }
          {
            Invidious = {
              icon = "invidious.svg";
            };
          }
          {
            Jellyfin = {
              icon = "jellyfin.svg";
              href = "https://media.gappyland.org/jellyfin";
              siteMonitor = "https://media.gappyland.org/jellyfin";
              target = "_self";
            };
          }
          {
            Jellyseerr = {
              icon = "jellyseerr.svg";
            };
          }
          {
            Komga = {
              icon = "komga.svg";
            };
          }
        ];
      }

      {
        AI = [
          {
            OpenWebUI = {
              icon = "https://github.com/open-webui/open-webui/blob/main/static/favicon.png?raw=true";
            };
          }
          {
            Automatic1111 = {
              icon = "https://user-images.githubusercontent.com/36368048/196280761-1535f413-a91e-4b6a-af6a-b890f8ae204c.png";
            };
          }
        ];
      }

      {
        Management = [
          {
            LLDAP = {
              icon = "freeipa.svg";
              href = "https://users.gappyland.org";
              target = "_self";
            };
          }
          {
            Beszel = {
              icon = "beszel.svg";
            };
          }
        ];
      }
    ];

    widgets = [
      {
        logo.icon = "/images/logo.png";
      }
      {
        datetime = {
          text_size = "l";
          format = {
            timeStyle = "short";
            dateStyle = "short";
            hourCycle = "h23";
          };
        };
      }
      {
        search = {
          provider = "duckduckgo";
          focus = false;
          showSearchSuggestions = true;
          target = "_top";
        };
      }
      {
        openmeteo = {
          label = "Weather";
          latitude = "41.109700";
          longitude = "111.982700";
          timezone = "America/Denver";
          units = "imperial";
          cache = 5;
          format = {
            maximumFractionDigits = "1";
          };
        };
      }

    ];
  };

  sops.secrets."homepage/env".sopsFile = ../../../../secrets/x86-merkat-auth/secrets.yaml;
}
