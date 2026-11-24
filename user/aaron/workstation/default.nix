{ pkgs, ... }:
{
  users.users.aaron.extraGroups = [ "libvirtd" ];

  systemd.tmpfiles.rules = [
    "d /home/aaron/Projects 0700 aaron aaron"
  ];

  home-manager.users.aaron = {
    imports = [
      ./programs/mpv
      ./programs/librewolf
      ./programs/wezterm
      ../programs/vscode
      ../shared/gaming.nix
    ];

    xdg.configFile."mpv/mpv.conf".force = true;

    accounts.email.accounts.aaron.thunderbird.enable = true;

    programs.wezterm.enable = true;

    services = {
      gammastep = {
        dawnTime = "5:00-6:45";
        duskTime = "18:45-21:45";
        settings = {
          general = {
            adjustment-method = "wayland";
          };
        };
      };
    };

    dconf.settings = {
      # connects virt-manager to qemu
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };

    fonts.fontconfig.enable = true;

    systemd.user.timers.bedtime-notification = {
      Unit = {
        Description = "Timer for bedtime notification at 21:45.";
      };
      Timer = {
        OnCalendar = "*-*-* 21:45:00";
        Unit = "bedtime-notification.service";
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };

    systemd.user.services.bedtime-notification = {
      Unit = {
        Description = "Send a bedtime notification.";
      };
      Service = {
        ExecStart = "${pkgs.libnotify}/bin/notify-send \"Reminder\" \"It's 21:45. Time to wind down!\"";
        Type = "oneshot";
      };
    };

    programs.claude-code = {
      enable = true;
      settings = {
        showThinkingSummaries = true;
        sandbox = {
          enabled = true;
          failIfUnavailable = true;
        };
        permissions = {
          allow = [
            "Read(.)"
          ];
          blockReadsOutsideWorkingDirectories = true;
          deny = [
            # Personal files
            "Read(~/Documents/**)"
            "Read(~/Downloads/**)"
            "Read(~/Videos/**)"
            "Read(/run/media/**)"

            # System files
            "Read(/etc/**)"
            "Read(/mnt/**)"
            "Read(/nfs/**)"

            # Claudes configs
            "Edit(~/.claude/settings.json)"
            "Edit(.claude/settings.json)"

            # Secrets managed by NixOS / sops-nix / agenix
            "Read(/run/secrets/**)"
            "Read(/run/agenix/**)"
            "Read(/run/keys/**)"
            "Read(/var/lib/sops-nix/**)"
            "Read(/var/lib/agenix/**)"
            "Read(/etc/ssh/**)"
            "Read(/etc/wireguard/**)"
            "Read(/etc/NetworkManager/system-connections/**)"
            "Read(/etc/shadow)"
            "Read(/etc/gshadow)"
            "Read(**/*secret*)"
            "Read(**/*secrets*)"
            "Read(**/*.age)"
            "Read(**/sops/**)"

            # Nix store derivations that may embed secrets
            "Read(/nix/store/*secret*)"
            "Read(/nix/store/*password*)"
            "Read(/nix/store/*token*)"
            "Read(/nix/store/*key*)"
            "Read(/nix/store/*.pem)"
            "Read(/nix/store/*.age)"

            # User cryptographic & auth keys
            "Read(~/.ssh/**)"
            "Read(~/.gnupg/**)"
            "Read(~/.config/sops/**)"
            "Read(~/.config/age/**)"
            "Read(~/.pki/**)"

            # Cloud, container & CLI credentials
            "Read(~/.aws/**)"
            "Read(~/.azure/**)"
            "Read(~/.config/gcloud/**)"
            "Read(~/.kube/**)"
            "Read(~/.docker/config.json)"
            "Read(~/.config/gh/**)"
            "Read(~/.git-credentials)"
            "Read(~/.netrc)"
            "Read(~/.npmrc)"
            "Read(~/.pypirc)"
            "Read(~/.cargo/credentials*)"
            "Read(~/.terraform.d/**)"
            "Read(~/.vault-token)"

            # Password managers & keyrings
            "Read(~/.local/share/keyrings/**)"
            "Read(~/.password-store/**)"
            "Read(~/.config/Bitwarden CLI/**)"
            "Read(~/.config/op/**)"

            # Project-level secrets & env files
            "Read(**/.env)"
            "Read(**/.env.*)"
            "Read(**/.dev.vars*)"
            "Read(**/*.pem)"
            "Read(**/*.key)"
            "Read(**/*.p12)"
            "Read(**/*.pfx)"
            "Read(**/credentials/**)"
            "Read(**/credentials.json)"
            "Read(**/*token*)"
            "Read(**/*password*)"

            "Read(~/.config/sops/age/**)"
            "Read(~/.docker/**)"
            "Read(**/.terraform/**)"
            "Read(~/.bash_history)"
            "Read(~/.zsh_history)"
            "Read(~/.mozilla/**)"
            "Read(~/.config/google-chrome/**)"
            "Read(~/.config/chromium/**)"
          ];
        };
        statusLine = {
          type = "command";
          command = "${pkgs.python3}/bin/python3 ${./statusline.py}";
        };
      };
      context = ''
        # Output & Narration Preferences
        - Before running any tool or editing a file, briefly explain what you are doing and why.
        - State key assumptions and explain the reasoning behind each step.
      '';
    };

    services.kdeconnect.enable = true;

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "librewolf.desktop";
        "video/mp4" = "mpv.desktop";
        "video/webm" = "mpv.desktop";
        "video/mpeg" = "mpv.desktop";
        "video/ogg" = "mpv.desktop";
        "image/jpeg" = "org.gnome.Loupe.desktop";
        "image/png" = "org.gnome.Loupe.desktop";
        "image/gif" = "org.gnome.Loupe.desktop";
        "image/webp" = "org.gnome.Loupe.desktop";
        "x-scheme-handler/http" = "librewolf.desktop";
        "x-scheme-handler/https" = "librewolf.desktop";
        "x-scheme-handler/about" = "librewolf.desktop";
        "x-scheme-handler/unknown" = "librewolf.desktop";
      };
    };
  };
}
