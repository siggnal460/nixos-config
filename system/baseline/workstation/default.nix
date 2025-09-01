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
    #"/nfs/ai" = {
    #  device = lib.mkForce "x86-atxtwr-computeserver:/export/ai";
    #  fsType = lib.mkForce "nfs4";
    #  options = mountOptions;
    #};
    #"/nfs/blender" = {
    #  device = lib.mkForce "x86-atxtwr-computeserver:/export/blender";
    #  fsType = lib.mkForce "nfs4";
    #  options = mountOptions;
    #};
    "/nfs/media" = {
      device = lib.mkForce "x86-rakmnt-mediaserver:/export/media";
      fsType = lib.mkForce "nfs4";
      options = mountOptions;
    };
  };

  networking.networkmanager.enable = true;

  programs = {
    evince.enable = true;
    seahorse.enable = true;
    gnome-disks.enable = true;
    thunderbird.enable = true;
    gnupg.agent = {
      # gpg keys
      enable = true;
      enableSSHSupport = true;
    };
  };

  services = {
    xserver.displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    openssh.enable = false;
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

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  hardware.nvidia.nvidiaSettings = lib.mkIf (builtins.elem "nvidia" config.boot.initrd.kernelModules) true;

  environment = {
    systemPackages = with pkgs; [
      anki
      deluge
      element-desktop
      #firefox
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
      wezterm
      wl-clipboard
      wineWowPackages.waylandFull
      waypipe
      usbimager
    ];
  };
}
