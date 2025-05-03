{
  pkgs,
  ...
}:
{
  imports = [
    ../../shared/plymouth.nix
    ../../shared/pipewire.nix
    ../../shared/nfs-client.nix
  ];

  environment.sessionVariables = rec {
    NIGHTLY_REFRESH = "always-poweroff";
  };

  networking.networkmanager.enable = true;

  services.openssh.enable = false;

  programs = {
    evince.enable = true;
    #firejail.enable = true;
    gnupg.agent = {
      # gpg keys
      enable = true;
      enableSSHSupport = true;
    };
    #firejail = {
    #  wrappedBinaries = {
    #    firefox = {
    #      executable = "${pkgs.lib.getBin pkgs.firefox}/bin/firefox";
    #      profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
    #    };
    #  };
    #};
  };

  services = {
    printing.enable = true; # will need to specify your drivers
    printing.drivers = [ pkgs.brlaser ];
    fwupd.enable = true; # for upgrading firmware
    pcscd.enable = true; # needed for gpg keys
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

  services.flatpak.enable = true;

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

  environment = {
    systemPackages = with pkgs; [
      anki
      calibre
      element-desktop
      eog
      deluge
      firefox
      gimp
      gnupg
      gparted
      jellyfin-media-player
      libreoffice
      #loupe
      mpv
      openvpn
      #rustdesk
      spotube
      thunderbird
      tor-browser
      usbimager
      image-roll
      wl-clipboard
      wineWowPackages.waylandFull
      vencord
      vesktop
      waypipe
      qiv
      phototonic
      kdePackages.gwenview
    ];
  };
}
