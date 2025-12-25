{
  inputs,
  lib,
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
    ../../de/cosmic
    inputs.jovian-nixos.nixosModules.default
    inputs.lsfg-vk-flake.nixosModules.default
  ];

  systemd.services.rebuild.environment = {
    NIGHTLY_REFRESH = "poweroff-always";
  };

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
      desktopSession = "cosmic-uwsm";
      enable = true;
      autoStart = true;
      user = "aaron";
    };
  };

  services = {
    lsfg-vk = {
      ui.enable = lib.mkForce false;
    };
  };

  xdg.autostart.enable = true;
}
