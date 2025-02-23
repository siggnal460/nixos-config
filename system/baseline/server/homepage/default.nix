{ config, ... }:
{
  services.homepage-dashboard = {
    enable = true;
    openFirewall = true;
    environmentFile = config.sops.secrets."homepage/env".path;

    settings = {
      title = "Gappyland";
      description = "Gappy Makes Me Happy";
      hideVersion = true;
      theme = "dark";
      background = {
        image = "https://i.imgur.com/xVWaGv3.jpeg";
        blur = "sm";
        saturate = "50";
        brightness = "50";
        opacity = "50";
      };
      favicon = "../../../../images/icons/menacing.ico";
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
              ping = "https://media.gappyland.org/jellyfin";
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
