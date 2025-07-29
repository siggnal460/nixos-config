{ ... }:
{
  imports = [
    ../../shared/plymouth-tv.nix
    ../../shared/pipewire.nix
    ../../shared/bluetooth.nix
    ../../shared/remotely-managed.nix
    ../../shared/networkmanager.nix
    ../../shared/gaming-tweaks.nix
  ];

  systemd.services.rebuild.environment = {
    NIGHTLY_REFRESH = "poweroff-always";
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
  services.desktopManager.gnome.enable = true;

  xdg.autostart.enable = true;
}
