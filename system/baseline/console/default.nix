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
    ../../de/plasma
    inputs.jovian-nixos.nixosModules.default
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
      desktopSession = "plasma";
      enable = true;
      autoStart = true;
      user = "aaron";
    };
  };

  hardware.steam-hardware.enable = true;

  services = {
    flatpak.enable = true;
    lsfg-vk = {
      ui.enable = lib.mkForce false;
    };
  };

  xdg.autostart.enable = true;

  systemd.services.steam-cef-debug = lib.mkIf config.jovian.decky-loader.enable {
    description = "Create Steam CEF debugging file";
    serviceConfig = {
      Type = "oneshot";
      User = config.jovian.steam.user;
      ExecStart = "/bin/sh -c 'mkdir -p ~/.steam/steam && [ ! -f ~/.steam/steam/.cef-enable-remote-debugging ] && touch ~/.steam/steam/.cef-enable-remote-debugging || true'";
    };
    wantedBy = [ "multi-user.target" ];
  };

  environment.systemPackages = with pkgs; [
    maliit-keyboard
    maliit-framework
  ];
}
