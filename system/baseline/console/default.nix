{
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [
    ../../shared/plymouth-quiet.nix
    ../../shared/pipewire.nix
    ../../shared/bluetooth.nix
    ../../shared/remotely-managed.nix
    ../../shared/networkmanager.nix
    ../../shared/gaming-tweaks.nix
    inputs.jovian-nixos.nixosModules.default
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

  services = {
    desktopManager.gnome.enable = true;
    lsfg-vk = {
      enable = lib.mkIf (config.jovian.steam.enable) true;
      ui.enable = false;
    };
  };

  xdg.autostart.enable = true;
}
