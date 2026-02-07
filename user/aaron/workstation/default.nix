{ pkgs, ... }:
{
  users.users.aaron.extraGroups = [ "libvirtd" ];

  systemd.tmpfiles.rules = [
    "d /home/aaron/Blender 0700 aaron aaron"
    "d /home/aaron/Blender/addons 0700 aaron aaron"
    "d /home/aaron/Blender/models 0700 aaron aaron"
    "d /home/aaron/Blender/models/male 0700 aaron aaron"
    "d /home/aaron/Blender/models/female 0700 aaron aaron"
    "d /home/aaron/Blender/models/objects 0700 aaron aaron"
    "d /home/aaron/Blender/environments 0700 aaron aaron"
    "d /home/aaron/Projects 0700 aaron aaron"
  ];

  home-manager.users.aaron = {
    imports = [
      ./programs/mpv
      ./programs/librewolf
      ./programs/wezterm
      ../shared/gaming.nix
    ];

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
