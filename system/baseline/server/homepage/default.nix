{
  pkgs,
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
      ln -s ${icon} $out/share/homepage/public/images/favicon.ico
      ln -s ${logo} $out/share/homepage/public/images/logo.png
    '';
  });
in
{
  services.homepage-dashboard = {
    enable = true;
    package = package;
    openFirewall = true;

    customCSS = ''
      			#revalidate {
      				display: none;
      			}
      		'';

    settings = {
      title = "Gappyland";
      description = "Gappy Makes Me Happy";
      hideVersion = true;
      theme = "dark";
      language = "en";
      background = {
        image = "/images/background.jpeg";
        blur = "sm";
        saturate = "50";
        brightness = "50";
        opacity = "50";
      };
      favicon = "/images/favicon.ico";
      statusStyle = "dot";
      quicklaunch = {
        searchDescriptions = true;
        hideInternetSearch = true;
        showSearchSuggestions = true;
        hideVisitURL = true;
        provider = "duckduckgo";
      };
      color = "slate";
      target = "_self";
    };

    services = [
      {
        Nextcloud = [
          {
            Dashboard = {
              icon = "nextcloud.svg";
              href = "https://cloud.gappyland.org/apps/dashboard";
            };
          }
          {
            Calendar = {
              icon = "nextcloud-calendar.svg";
              href = "https://cloud.gappyland.org/apps/calendar";
            };
          }
          {
            Contacts = {
              icon = "nextcloud-contacts.svg";
              href = "https://cloud.gappyland.org/apps/contacts";
            };
          }
          {
            Files = {
              icon = "nextcloud-files.svg";
              href = "https://cloud.gappyland.org/apps/files";
            };
          }
          {
            News = {
              icon = "nextcloud-news.svg";
              href = "https://cloud.gappyland.org/apps/news";
            };
          }
          {
            Notes = {
              icon = "nextcloud-notes.svg";
              href = "https://cloud.gappyland.org/apps/notes";
            };
          }
          {
            Tasks = {
              icon = "nextcloud-tasks.svg";
              href = "https://cloud.gappyland.org/apps/tasks";
            };
          }
        ];
      }

      {
        Media = [
          {
            EmulatorJS = {
              icon = "emulatorjs.svg";
              href = "https://roms.gappyland.org";
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
              href = "https://media.gappyland.org";
            };
          }
          {
            Jellyseerr = {
              icon = "jellyseerr.svg";
              href = "https://requests.gappyland.org";
            };
          }
          {
            Komga = {
              icon = "komga.svg";
              href = "https://books.gappyland.org";
            };
          }
        ];
      }

      {
        AI = [
          {
            InvokeAI = {
              icon = "invoke-ai";
              href = "https://imagegen.gappyland.org";
            };
          }
          {
            OpenWebUI = {
              icon = "https://github.com/open-webui/open-webui/blob/main/static/favicon.png?raw=true";
              href = "https://textgen.gappyland.org";
            };
          }
        ];
      }

      {
        Management = [
          {
            Authelia = {
              icon = "authelia.svg";
              href = "https://auth.gappyland.org";
            };
          }
          {
            Beszel = {
              icon = "beszel.svg";
              href = "https://monitoring.gappyland.org";
            };
          }
          {
            Gitea = {
              icon = "gitea.svg";
            };
          }
          {
            HomeAssistant = {
              icon = "home-assistant.svg";
            };
          }
          {
            Linkwarden = {
              icon = "linkwarden.png";
              href = "https://linkwarden.gappyland.org";
            };
          }
          {
            LLDAP = {
              icon = "freeipa.svg";
              href = "https://users.gappyland.org";
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
        search = {
          provider = "duckduckgo";
          focus = true;
          showSearchSuggestions = true;
          target = "_top";
        };
      }
      {
        datetime = {
          text_size = "sm";
          locale = "de";
          format = {
            hourCycle = "h23";
            dateStyle = "short";
            timeStyle = "short";
          };
        };
      }
    ];

    bookmarks = [
      {
        Development = [
          {
            Github = [
              {
                icon = "github.svg";
                href = "https://github.com/";
              }
            ];
          }
          {
            Python = [
              {
                icon = "python.svg";
                href = "https://docs.python.org/";
              }
            ];
          }
          {
            Rust = [
              {
                icon = "rust.svg";
                href = "https://docs.rs";
              }
            ];
          }
        ];
      }

      {
        Containers = [
          {
            Dockerhub = [
              {
                icon = "docker.svg";
                href = "https://hub.docker.com";
              }
            ];
          }
          {
            Linuxserver = [
              {
                icon = "linuxserver-io.svg";
                href = "https://docs.linuxserver.io";
              }
            ];
          }
        ];
      }

      {
        Linux = [
          {
            NixOS = [
              {
                icon = "nixos.svg";
                href = "https://search.nixos.org/options";
              }
            ];
          }
          {
            Home-Manager = [
              {
                icon = "nixos.svg";
                href = "https://nix-community.github.io/home-manager/options.xhtml";
              }
            ];
          }
        ];
      }

      {
        Selfhosting = [
          {
            Authelia = [
              {
                icon = "authelia.svg";
                href = "https://www.authelia.com/";
              }
            ];
          }
          {
            Caddy = [
              {
                icon = "caddy.svg";
                href = "https://caddyserver.com/docs/";
              }
            ];
          }
          {
            Cloudflare = [
              {
                icon = "cloudflare.svg";
                href = "https://dash.cloudflare.com/";
              }
            ];
          }
          {
            Homepage = [
              {
                icon = "homepage.png";
                href = "https://gethomepage.dev/";
              }
            ];
          }
        ];
      }
    ];
  };
}
