# I use COSMIC, GNOME, and Hyprland as my desktops and GDM as my display manager
{
  pkgs,
  lib,
  config,
  ...
}:
let
  mountOptions = [
    "x-systemd.automount"
    "noauto"
    "x-systemd.idle-timeout=60"
    "_netdev"
  ];
in
{
  imports = [
    ../../shared/plymouth.nix
    ../../shared/pipewire.nix
    ../../shared/nfs-client.nix
  ];

  systemd = {
    services.rebuild.environment = {
      NIGHTLY_REFRESH = "poweroff-always";
    };

    tmpfiles.rules = [
      "d /nfs/ai 0770 root ai"
      "d /nfs/blender 0770 root users"
      "d /nfs/media 0770 root media"
    ];
  };

  fileSystems = {
    "/nfs/ai" = {
      device = lib.mkForce "x86-atxtwr-computeserver:/export/ai";
      fsType = lib.mkForce "nfs4";
      options = mountOptions;
    };
    "/nfs/blender" = {
      device = lib.mkForce "x86-atxtwr-computeserver:/export/blender";
      fsType = lib.mkForce "nfs4";
      options = mountOptions;
    };
    "/nfs/media" = {
      device = lib.mkForce "x86-rakmnt-mediaserver:/export/media";
      fsType = lib.mkForce "nfs4";
      options = mountOptions;
    };
  };

  networking.networkmanager.enable = true;

  services.openssh.enable = false;

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };
    evince.enable = true;
    seahorse.enable = true;
    gnome-disks.enable = true;
    uwsm = {
      enable = true;
      waylandCompositors.cosmic = {
        prettyName = "COSMIC";
        comment = "System76's COSMIC Desktop Environment";
        binPath = "/run/current-system/sw/bin/cosmic-session";
      };
    };
    thunderbird.enable = true;
    gnupg.agent = {
      # gpg keys
      enable = true;
      enableSSHSupport = true;
    };
  };

  services = {
    xserver.enable = true;
    xserver.desktopManager.gnome.enable = true;
    xserver.displayManager.gdm.enable = true;
    printing.enable = true;
    printing.drivers = [ pkgs.brlaser ];
    fwupd.enable = true; # for upgrading firmware
    pcscd.enable = true; # needed for gpg keys
    flatpak.enable = true;
    udev.packages = with pkgs; [ gnome-settings-daemon ]; # for gnome extensions
    /*
      		doesn't do anything on wayland I think
      				libinput.mouse = {
      					accelProfile = "custom";
      					accelStepMotion = 1;
      					accelPointsMotion = [
      						0.0
      			0.0
      			4.0
      			11.0
      			27.0
      					];
      				};
    */
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

  hardware.nvidia.nvidiaSettings = lib.mkIf (builtins.elem "nvidia" config.boot.initrd.kernelModules) true;

  environment = {
    gnome.excludePackages = (
      with pkgs;
      [
        atomix # puzzle game
        cheese # webcam tool
        epiphany # web browser
        geary # email reader
        gedit # text editor
        gnome-characters
        gnome-music
        gnome-photos
        gnome-terminal
        gnome-tour
        hitori # sudoku game
        iagno # go game
        tali # poker game
        totem # video player
      ]
    );
    systemPackages = with pkgs; [
      anki
      deluge
      element-desktop
      firefox
      gimp
      gnomeExtensions.appindicator
      gnupg
      jellyfin-media-player
      libreoffice
      logseq
      loupe
      mpv
      openvpn
      protonmail-bridge-gui
      tor-browser
      wayland-utils
      wl-clipboard
      wineWowPackages.waylandFull
      waypipe
      usbimager
    ];
  };
}
