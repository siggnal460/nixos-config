{
  pkgs,
  inputs,
  config,
  pkgsStable,
  ...
}:
{
  imports = [
    ../../shared/plymouth.nix
    ../../shared/pipewire.nix
    ../../shared/bluetooth.nix
    ../../shared/nfs-client.nix
  ];

  _module.args.pkgsStable = import inputs.nixpkgs {
    inherit (pkgs.stdenv.hostPlatform) system;
    inherit (config.nixpkgs) config;
  };

  services.openssh.enable = false;

  programs = {
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
      						flatpak install --or-update -y flathub dev.vencord.Vesktop
    '';
  };

  environment = {
    systemPackages = with pkgs; [
      anki
      pkgsStable.calibre
      element-desktop
      firefox
      gimp
      gnupg
      gparted
      jellyfin-media-player
      libreoffice
      pkgsStable.logseq
      loupe
      mpv
      openvpn
      spotube
      thunderbird
      tor-browser
      usbimager
      wl-clipboard
      wineWowPackages.waylandFull
      vencord
      vesktop
    ];
  };
}