{
  pkgs,
  lib,
  config,
  ...
}:
let
  jellyseerrApiFile = "/var/lib/doplarr/jellyseerr_api";
  discordApiFile = "/var/lib/doplarr/discord_api";
  auth_site = "https://auth.gappyland.org";
in
{
  imports = [ ../../../shared/podman.nix ];

  systemd.tmpfiles.rules = [
    #"d /var/lib/doplarr 0400 doplarr root"
    #"f /var/lib/doplarr/jellyseerr_api 0400 doplarr root"
    #"f /var/lib/doplarr/discord_api 0400 doplarr root"
    "d /export/media 0775 root root"
    "d /etc/bazarr 0770 bazarr users"
    "d /etc/doplarr 0770 doplarr users"
    "d /etc/jellyfin 0770 jellyfin users"
    "d /etc/jellyseerr 0770 root users"
    "d /etc/komga 0770 komga users"
    "d /etc/lidarr 0770 prowlarr users"
    "d /etc/prowlarr 0770 prowlarr users"
    "d /etc/radarr 0770 radarr users"
    "d /etc/readarr 0770 readarr users"
    "d /etc/sonarr 0770 sonarr users"
    "d /etc/sonarr-anime 0770 sonarr-anime users"
    "d /etc/wizarr 0770 wizarr wizarr"
    "d /export/media/data 0775 root media"
    "d /export/media/data/dlna 0770 aaron media"
    "d /export/media/data/anime 0775 root media"
    "d /export/media/data/books 0775 root media"
    "d /export/media/data/books/comics 0775 root media"
    "d /export/media/data/books/manga 0775 root media"
    "d /export/media/data/books/regular 0775 root media"
    "d /export/media/data/courses 0775 root media"
    "d /export/media/data/movies 0775 root media"
    "d /export/media/data/music 0775 root media"
    "d /export/media/data/tvshows 0775 root media"
    "d /export/media/data/workouts 0775 root media"
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
    wizarr = {
      uid = 712;
      isSystemUser = true;
      group = "wizarr";
    };
  };

  users.groups = {
    wizarr = {
      gid = 712;
    };
  };

  environment.etc."komga/application.yml".source =
    lib.mkForce config.sops.templates.komga-config.path;
  sops.templates.komga-config = {
    content = # yaml
      ''
        				komga:
        					oauth2-account-creation: true
        				spring:
        					security:
        						oauth2:
        							client:
        								registration:
        									authelia:
        										client-id: "${config.sops.placeholder."komga/oidc_client_id"}"
        										client-secret: "${config.sops.placeholder."komga/oidc_client_secret"}"
        										client-name: 'Authelia'
        										scope: 'openid,profile,email'
        										authorization-grant-type: 'authorization_code'
        										redirect-uri: "{baseScheme}://{baseHost}{basePort}{basePath}/login/oauth2/code/authelia"
        								provider:
        									authelia:
        										issuer-uri: '${auth_site}'
        										user-name-attribute: 'preferred_username'
      '';
    owner = "komga";
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
  };

}
