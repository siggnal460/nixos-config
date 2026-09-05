{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ../../shared/plymouth-verbose.nix
    ../../shared/pipewire.nix
    #../../shared/nfs-client.nix
    ../../shared/cosmic-greeter.nix
  ];

  networking.firewall = rec {
    # for KDE connect
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };

  systemd = {
    services.rebuild.environment = {
      NIGHTLY_REFRESH = "poweroff-always";
    };

    # tmpfiles.rules = [
    #  "d /nfs/ai 0770 root ai"
    # ];
  };

  # fileSystems = {
  #   "/nfs/ai" = {
  #     device = lib.mkForce "x86-atxtwr-computeserver:/export/ai";
  #     fsType = lib.mkForce "nfs4";
  #     options = mountOptions;
  #   };
  # };

  networking.networkmanager.enable = true;

  services = {
    displayManager.cosmic-greeter = {
      enable = true;
    };
    openssh.enable = false;
    printing.enable = true;
    printing.drivers = [ pkgs.brlaser ];
    fwupd.enable = true; # for upgrading firmware
    pcscd.enable = true; # needed for gpg keys
    flatpak.enable = true;
  };

  systemd.services.flatpak-install = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      flatpak uninstall --unused -y --noninteractive
      flatpak install -y --noninteractive flathub com.discordapp.Discord
      flatpak update -y
    '';
  };

  xdg = {
    terminal-exec = {
      enable = true;
      settings.default = [ "org.wezfurlong.wezterm.desktop" ];
    };
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal
        pkgs.xdg-desktop-portal-gtk
      ];
      config = {
        common = {
          default = [ "cosmic" ];
        };
      };
    };
    mime.defaultApplications = {
      "inode/directory" = "com.system76.CosmicFiles.desktop";
      "text/plain" = "com.system76.CosmicEdit.desktop";
      "text/markdown" = "com.system76.CosmicEdit.desktop";
      "application/x-shellscript" = "com.system76.CosmicEdit.desktop";
      "application/pdf" = "com.system76.CosmicReader.desktop";
      "image/jpeg" = "org.gnome.Loupe.desktop";
      "image/png" = "org.gnome.Loupe.desktop";
      "image/gif" = "org.gnome.Loupe.desktop";
      "image/webp" = "org.gnome.Loupe.desktop";
      "video/mp4" = "mpv.desktop";
      "video/mkv" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
      "video/*" = "mpv.desktop";
    };
  };

  hardware.nvidia.nvidiaSettings = lib.mkIf (builtins.elem "nvidia" config.boot.initrd.kernelModules) true;
  programs.kdeconnect.enable = true;

  environment = {
    plasma6.excludePackages = with pkgs; [
      kdePackages.kate
      kdePackages.kwrited
      kdePackages.gwenview
      kdePackages.konsole
      kdePackages.discover
      kdePackages.dolphin
      kdePackages.okular
      kdePackages.elisa
      kdePackages.spectacle
    ];
    cosmic.excludePackages = [
      pkgs.cosmic-term
      pkgs.cosmic-player
    ];
  };

  programs.thunderbird.enable = true;

  environment = {
    systemPackages = with pkgs; [
      anki
      deluge
      easyeffects
      element-desktop
      firefox
      gimp
      gnupg
      jellyfin-media-player
      libation
      libreoffice
      #logseq
      loupe
      mpv
      networkmanager-openvpn
      opensc
      openvpn
      protonmail-bridge-gui
      teams-for-linux
      tor-browser
      wayland-utils
      wezterm
      wl-clipboard
      waypipe
      usbimager
      unstable.yt-dlp
    ];
  };
}
