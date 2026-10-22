{
  pkgs,
  lib,
  config,
  ...
}:
let
  mountOptions = [
    "x-systemd.automount"
    "x-systemd.device-timeout=2s"
    "x-systemd.mount-timeout=2s"
    "x-systemd.idle-timeout=600" # 10min
    "bg"
    "noauto"
    "nofail"
  ];
in
{
  imports = [
    ../../shared/plymouth-verbose.nix
    ../../shared/pipewire.nix
    ../../shared/nfs-client.nix
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

    tmpfiles.rules = [
      "d /nfs/media 0770 root media"
    ];
  };

  fileSystems = {
    "/nfs/media" = {
      device = lib.mkForce "x86-rakmnt-mediaserver:/export/media";
      fsType = lib.mkForce "nfs4";
      options = mountOptions;
    };
  };

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
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    path = [ pkgs.flatpak ];
    serviceConfig.Type = "oneshot";
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
      xdgOpenUsePortal = true;

      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-cosmic
      ];
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

  environment.cosmic.excludePackages = [
    pkgs.cosmic-term
    pkgs.cosmic-player
  ];

  programs.thunderbird.enable = true;

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  programs.appimage.package = pkgs.appimage-run.override {
    extraPkgs = pkgs: [
      pkgs.icu
      pkgs.libxcrypt-legacy
      pkgs.python312
      pkgs.python312Packages.torch
    ];
  };

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
      unstable.libation
      libreoffice
      #logseq
      loupe
      mpv
      networkmanager-openvpn
      opensc
      openvpn
      pear-desktop
      protonmail-bridge-gui
      signal-desktop
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
