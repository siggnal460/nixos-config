{ pkgs, ... }:
{
  programs = {
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
	};

  services = {
	  desktopManager.cosmic.enable = true;
    displayManager.cosmic-greeter.enable = true;
		gnome.gnome-keyring.enable = true;
	};

  environment = {
    systemPackages = with pkgs; [
      deluge
      loupe
			usbimager
    ];
  };
}
