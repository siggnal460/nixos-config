{ lib, ... }:
{
  imports = [
    ../../shared/plymouth.nix
    ../../shared/quietboot.nix
    ../../shared/pipewire.nix
    ../../shared/bluetooth.nix
    ../../shared/remotely-managed.nix
    ../../shared/networkmanager.nix
  ];

  systemd.services.rebuild.environment = {
	  NIGHTLY_REFRESH = "always-poweroff";
	};

  networking.networkmanager.enable = true;

  nixpkgs.allowUnfreePackages = [
    "steam"
    "steam-jupiter-original"
    "steamdeck-hw-theme"
    "steam-jupiter-unwrapped"
  ];

  jovian = {
    steamos.useSteamOSConfig = true;
    decky-loader = {
      enable = true;
    };
    steam = {
      desktopSession = "gnome";
      enable = true;
      autoStart = true;
      user = "aaron";
    };
  };

  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.displayManager.cosmic-greeter.enable = lib.mkForce false;

  xdg.autostart.enable = true;
}
