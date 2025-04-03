{
  pkgs,
  lib,
  config,
  ...
}:
let
  auth_site = "https://auth.gappyland.org";
in
{
  imports = [ ../../../shared/podman.nix ];

  systemd.tmpfiles.rules = [
    #"d /var/lib/doplarr 0400 doplarr root"
    #"f /var/lib/doplarr/jellyseerr_api 0400 doplarr root"
    #"f /var/lib/doplarr/discord_api 0400 doplarr root"
    "d /etc/bazarr 0770 bazarr wheel"
    "d /etc/doplarr 0770 doplarr wheel"
    "d /etc/jellyfin 0775 jellyfin wheel"
    "d /etc/jellyseerr 0770 root wheel"
    "d /etc/komga 0770 komga wheel"
    "d /etc/lidarr 0770 prowlarr wheel"
    "d /etc/prowlarr 0770 prowlarr wheel"
    "d /etc/radarr 0770 radarr wheel"
    "d /etc/readarr 0770 readarr wheel"
    "d /etc/recyclarr 0770 recyclarr wheel"
    "d /etc/sonarr 0770 sonarr wheel"
    "d /etc/sonarr-anime 0770 sonarr-anime wheel"
    "d /export/backups 0774 restic wheel"
    "d /export/backups/jellyfin 0774 restic wheel"
    "d /export/media 0775 root root"
    "d /export/media/data 0775 root media"
    "d /export/media/data/anime 0775 sonarr-anime media"
    "d /export/media/data/books 0775 root media"
    "d /export/media/data/books/comics 0775 root media"
    "d /export/media/data/books/manga 0775 root media"
    "d /export/media/data/books/regular 0775 root media"
    "d /export/media/data/courses 0775 root media"
    "d /export/media/data/movies 0775 radarr media"
    "d /export/media/data/music 0775 root media"
    "d /export/media/data/tvshows 0775 sonarr media"
    "d /export/media/data/workouts 0775 sonarr media"
  ];

  services = {
    nfs.server = {
      exports = ''/export/media 10.0.0.15(rw,nohide,insecure,no_subtree_check)'';
    };
    fail2ban = {
      jails = {
        jellyfin = {
          settings = {
            enabled = "true";
            backend = "auto";
            port = "80,443";
            protocol = "tcp";
            filter = "jellyfin";
            maxretry = "3";
            bantime = "86400";
            findtime = "43200";
            logpath = "/etc/jellyfin/log/log*.log";
            action = "iptables-allports[name=jellyfin, chain=DOCKER-USER]";
          };
        };
      };
    };
    restic = {
      backups.jellyfin = {
        initialize = true;
        user = "restic";
        repository = "/export/backups/jellyfin";
        passwordFile = "/run/secrets/restic-password";
        paths = [
          "/etc/jellyfin"
        ];
        exclude = [
          "/etc/jellyfin/cache"
        ];
        pruneOpts = [
          "--keep-latest"
          "--keep-weekly 4"
        ];
        backupPrepareCommand = "sudo podman stop jellyfin";
        backupCleanupCommand = "sudo podman start jellyfin";
        timerConfig.OnCalendar = "*-*-* 0:30:00";
      };
    };
  };

  environment.etc = {
    "fail2ban/filter.d/jellyfin.conf".text = pkgs.lib.mkDefault (
      pkgs.lib.mkAfter ''
        [Definition]
        failregex = ^.*Authentication request for .* has been denied \(IP: "<ADDR>"\)\.
      ''
    );
  };

  users.users = {
    jellyfin = {
      uid = 700;
      isSystemUser = true;
      group = "media";
    };
    radarr = {
      uid = 701;
      isSystemUser = true;
      group = "media";
    };
    jellyseerr = {
      uid = 702;
      isSystemUser = true;
      group = "media";
    };
    bazarr = {
      uid = 703;
      isSystemUser = true;
      group = "media";
    };
    prowlarr = {
      uid = 704;
      isSystemUser = true;
      group = "media";
    };
    sonarr = {
      uid = 705;
      isSystemUser = true;
      group = "media";
    };
    sonarr-anime = {
      uid = 706;
      isSystemUser = true;
      group = "media";
    };
    doplarr = {
      uid = 707;
      isSystemUser = true;
      group = "media";
    };
    komga = {
      uid = 708;
      isSystemUser = true;
      group = "media";
    };
    readarr = {
      uid = 709;
      isSystemUser = true;
      group = "media";
    };
    recyclarr = {
      uid = 713;
      isSystemUser = true;
      group = "recyclarr";
    };
    restic = {
      uid = 760;
      isSystemUser = true;
      group = "restic";
    };
  };

  users.groups = {
    recyclarr = {
      gid = 713;
    };
    restic = {
      gid = 760;
    };
  };

  security = {
    wrappers.restic = {
      source = "${pkgs.restic.out}/bin/restic";
      owner = "restic";
      group = "restic";
      permissions = "u=rwx,g=,o=";
      capabilities = "cap_dac_read_search=+ep";
    };
    sudo = {
      enable = true;
      execWheelOnly = true;
      extraRules = [
        {
          commands =
            builtins.map
              (command: {
                command = "/run/current-system/sw/bin/${command}";
                options = [ "NOPASSWD" ];
              })
              [
                "podman"
              ];
          users = [ "restic" ];
        }
      ];
    };
  };

  environment.etc = {
    "recyclarr/recyclarr.yml".source = lib.mkForce config.sops.templates.recyclarr-config.path;
    "komga/application.yml".source = lib.mkForce config.sops.templates.komga-config.path;
  };

  sops.templates.recyclarr-config = {
    owner = "recyclarr";
    file = (pkgs.formats.yaml { }).generate "yaml" {
      radarr = {
        main = {
          base_url = "!secret ${config.sops.placeholder."recyclarr/radarr_url"}";
          api_key = "!secret ${config.sops.placeholder."recyclarr/radarr_api"}";
          media_naming = {
            folder = "jellyfin";
            movie = {
              rename = "true";
              standard = "jellyfin";
            };
          };
          quality_definition = {
            type = "movie";
            preferred_ratio = "0.5";
          };
          quality_profiles = {
            name = "TraSH";
          };
          delete_old_custom_formats = "false";
          replace_existing_custom_formats = "false";
          custom_formats = {
            trash_ids = [
              # Good
              "570bc9ebecd92723d2d21500f4be314c" # Remaster
              "eca37840c13c6ef2dd0262b141a5482f" # 4K Remaster
              "e0c07d59beb37348e975a930d5e50319" # Criterion Collection
              "9d27d9d2181838f76dee150882bdc58c" # Masters of Cinema
              "db9b4c4b53d312a3ca5f1378f6440fc9" # Vinegar Syndrome
              "957d0f44b592285f26449575e8b1167e" # Special Edition
              "eecf3a857724171f968a66cb5719e152" # IMAX
              "9f6cbff8cfe4ebbc1bde14c7b7bec0de" # IMAX Enhanced
              # Bad
              "b6832f586342ef70d9c128d40c07b872" # Bad dual groups
              "90cedc1fea7ea5d11298bebd3d1d3223" # EVO (no WEBDL)
              "ae9b7c9ebde1f3bd336a8cbd1ec4c5e5" # No RIsGroup
              "7357cf5161efbf8c4d5d0c30b4815ee2" # Obfuscated
              "5c44f52a8714fdd79bb4d98e2673be1f" # Retags
              "f537cf427b64c38c8e36298f657e4828" # Scene
            ];
          };
          assign_score_to = {
            name = "TraSH";
          };
        };
      };
    };
  };

  sops.templates.komga-config = {
    owner = "komga";
    file = (pkgs.formats.yaml { }).generate "yaml" {
      komga = {
        oauth2-account-creation = "true";
      };
      spring = {
        security = {
          oath2 = {
            client = {
              registration = {
                authelia = {
                  client-id = "${config.sops.placeholder."komga/oidc_client_id"}";
                  client-secret = "${config.sops.placeholder."komga/oidc_client_secret"}";
                  client-name = "Authelia";
                  scope = "openid,profile,email";
                  authorization-grant-type = "authorization_code";
                  redirect-uri = "{baseScheme}://{baseHost}{basePort}{basePath}/login/oauth2/code/authelia";
                };
              };
              provider = {
                authelia = {
                  issuer-uri = "${auth_site}";
                  user-name-attribute = "preferred_username";
                };
              };
            };
          };
        };
      };
    };
  };

  virtualisation.oci-containers.containers = {
    jellyfin = {
      image = "lscr.io/linuxserver/jellyfin:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "8096:8096"
        "8920:8920"
        "7359:7359/udp"
        "1900:1900/udp"
      ];
      environment = {
        PUID = "700";
        PGID = "982";
        TZ = "America/Denver";
        NVIDIA_DRIVER_CAPABILITIES = "all";
        NVIDIA_VISIBLE_DEVICES = "1";
      };
      volumes = [
        "/etc/jellyfin:/config"
        "/export/media/data:/data"
      ];
      extraOptions = [
        "--name=jellyfin"
        "--gpus=1"
      ];
    };

    recyclarr = {
      image = "ghcr.io/recyclarr/recyclarr:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      user = "713:713";
      environment = {
        TZ = "America/Denver";
      };
      volumes = [
        "/etc/recyclarr:/config"
      ];
      extraOptions = [
        "--name=recyclarr"
      ];
    };

    radarr = {
      image = "lscr.io/linuxserver/radarr:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "7878:7878"
      ];
      environment = {
        PUID = "701";
        PGID = "982";
        TZ = "America/Denver";
      };
      volumes = [
        "/etc/radarr:/config"
        "/export/media:/data"
      ];
      extraOptions = [
        "--name=radarr"
      ];
    };

    sonarr = {
      image = "lscr.io/linuxserver/sonarr:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "8989:8989"
      ];
      environment = {
        PUID = "705";
        PGID = "982";
        TZ = "America/Denver";
      };
      volumes = [
        "/etc/sonarr:/config"
        "/export/media:/data"
      ];
      extraOptions = [
        "--name=sonarr"
      ];
    };

    sonarr-anime = {
      image = "lscr.io/linuxserver/sonarr:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "8988:8989"
      ];
      environment = {
        PUID = "706";
        PGID = "982";
        TZ = "America/Denver";
      };
      volumes = [
        "/etc/sonarr-anime:/config"
        "/export/media:/data"
      ];
      extraOptions = [
        "--name=sonarr-anime"
      ];
    };

    bazarr = {
      image = "lscr.io/linuxserver/bazarr:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "6767:6767"
      ];
      environment = {
        PUID = "703";
        PGID = "982";
        TZ = "America/Denver";
      };
      volumes = [
        "/etc/bazarr:/config"
        "/export/media/data/movies:/movies"
        "/export/media/data/tvshows:/tv"
      ];
      extraOptions = [
        "--name=bazarr"
      ];
    };

    prowlarr = {
      image = "lscr.io/linuxserver/prowlarr:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "9696:9696"
      ];
      environment = {
        PUID = "704";
        PGID = "982";
        TZ = "America/Denver";
      };
      volumes = [
        "/etc/prowlarr:/config"
      ];
      extraOptions = [
        "--name=prowlarr"
      ];
    };

    jellyseerr = {
      image = "docker.io/fallenbagel/jellyseerr:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "5055:5055"
      ];
      environment = {
        PUID = "702";
        PGID = "982";
        TZ = "America/Denver";
      };
      volumes = [
        "/etc/jellyseerr:/app/config"
      ];
      extraOptions = [
        "--name=jellyseerr"
      ];
    };

    komga = {
      image = "docker.io/gotson/komga:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "25600:25600"
      ];
      environment = {
        PUID = "708";
        PGID = "982";
        TZ = "America/Denver";
      };
      volumes = [
        "/etc/komga:/config"
        "/export/media/data/books:/data"
      ];
      extraOptions = [
        "--name=komga"
      ];
    };

    readarr = {
      image = "lscr.io/linuxserver/readarr:develop"; # TODO switch to stable when ready
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "8787:8787"
      ];
      environment = {
        PUID = "709";
        PGID = "982";
        TZ = "America/Denver";
      };
      volumes = [
        "/etc/readarr:/config"
        "/export/media:/data"
      ];
      extraOptions = [
        "--name=readarr"
      ];
    };

    #  #doplarr = {
    #  #  image = "docker.io/fallenbagel/doplarr:latest";
    #  #  autoStart = true;
    #  #  labels = {
    #  #    "io.containers.autoupdate" = "registry";
    #  #  };
    #  #  environment = {
    #  #    PUID = "707";
    #  #    PGID = "982";
    #  #    TZ = "America/Denver";
    #  #		FILE__DISCORD__TOKEN = "${discordApiFile}";
    #  #		FILE__OVERSEERR__API = "${jellyseerrApiFile}";
    #  #		OVERSEERR__URL = "http://host.docker.internal:5055";
    #  #  };
    #  #  volumes = [
    #  #    "/export/media/appdata/doplarr/data:/config"
    #  #  ];
    #  #  extraOptions = [
    #  #    "--name=doplarr"
    #  #  ];
    #  #};

    flaresolverr = {
      image = "ghcr.io/flaresolverr/flaresolverr:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [
        "8191:8191"
      ];
      environment = {
        TZ = "America/Denver";
      };
      extraOptions = [
        "--name=flaresolverr"
      ];
    };

    wizarr = {
      image = "ghcr.io/wizarrrr/wizarr:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      environment = {
        PUID = "712";
        PGID = "712";
      };
      ports = [
        "5690:5690"
      ];
      volumes = [
        "/etc/wizarr:/data/database"
      ];
    };
  };

  sops.secrets = {
    "komga/oidc_client_id".owner = "komga";
    "komga/oidc_client_secret".owner = "komga";
    "recyclarr/radarr_url".owner = "recyclarr";
    "recyclarr/radarr_api".owner = "recyclarr";
    "restic-password".owner = "restic";
  };
}
