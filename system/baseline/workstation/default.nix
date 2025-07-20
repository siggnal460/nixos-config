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

  systemd.services.rebuild.environment = {
    NIGHTLY_REFRESH = "poweroff-always";
  };

  networking.networkmanager.enable = true;

  services.openssh.enable = false;

  programs = {
    evince.enable = true;
		thunderbird.enable = true;
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
	  flatpak.enable = true;
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

  environment = {
    systemPackages = with pkgs; [
      anki
      element-desktop
      firefox
      gimp
      gnupg
      jellyfin-media-player
      libreoffice
      mpv
      openvpn
			protonmail-bridge-gui
      tor-browser
      wl-clipboard
      wineWowPackages.waylandFull
      waypipe
    ];
  };
}
