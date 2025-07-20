{ pkgs, ... }:
{
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  programs = {
    evince.enable = true;
		seahorse.enable = true;
    gnome-disks.enable = true;
	};

  services = {
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
