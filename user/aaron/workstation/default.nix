{ config, pkgs, ... }:
let
  losslessDll =
    if (config.gappyland.jovian) then
      "/home/aaron/.steam/steam/SteamApps/common/Lossless Scaling/Lossless.dll"
    else
      "/home/aaron/.var/app/com.valvesoftware.Steam/.steam/steam/steamapps/common/Lossless Scaling/Lossless.dll";
in
{
  users.users.aaron.extraGroups = [ "libvirtd" ];

  systemd.tmpfiles.rules = [
    "d /home/aaron/Blender 0700 aaron aaron"
    "d /home/aaron/Blender/addons 0700 aaron aaron"
    "d /home/aaron/Blender/models 0700 aaron aaron"
    "d /home/aaron/Blender/models/male 0700 aaron aaron"
    "d /home/aaron/Blender/models/female 0700 aaron aaron"
    "d /home/aaron/Blender/models/objects 0700 aaron aaron"
    "d /home/aaron/Blender/environments 0700 aaron aaron"
    "d /home/aaron/Projects 0700 aaron aaron"
    "d /home/aaron/Games 0700 aaron aaron"
    "L+ /home/aaron/Games/gog - - - - /nfs/games/gog"
    "L+ /home/aaron/Games/2ds - - - - /nfs/games/roms/2ds"
    "L+ /home/aaron/Games/3ds - - - - /nfs/games/roms/3ds"
    "L+ /home/aaron/Games/gb - - - - /nfs/games/roms/gb"
    "L+ /home/aaron/Games/gbc - - - - /nfs/games/roms/gbc"
    "L+ /home/aaron/Games/gba - - - - /nfs/games/roms/gba"
    "L+ /home/aaron/Games/gc - - - - /nfs/games/roms/gc"
    "L+ /home/aaron/Games/n64 - - - - /nfs/games/roms/n64"
    "L+ /home/aaron/Games/nes - - - - /nfs/games/roms/nes"
    "L+ /home/aaron/Games/ps1 - - - - /nfs/games/roms/ps1"
    "L+ /home/aaron/Games/ps2 - - - - /nfs/games/roms/ps2"
    "L+ /home/aaron/Games/ps3 - - - - /nfs/games/roms/ps3"
    "L+ /home/aaron/Games/psp - - - - /nfs/games/roms/psp"
    "L+ /home/aaron/Games/snex - - - - /nfs/games/roms/snes"
    "L+ /home/aaron/Games/wii - - - - /nfs/games/roms/wii"
    "L+ /home/aaron/Games/wiiu - - - - /nfs/games/roms/wiiu"
  ]
  ++ (
    if config.gappyland.jovian then
      [
        "L+ /home/aaron/Games/steam - - - - /home/aaron/.steam/steam/SteamApps/common"
      ]
    else
      [
        "L+ /home/aaron/Games/steam - - - - /home/aaron/.var/app/com.valvesoftware.Steam/.steam/steam/steamapps/common"
      ]
  );

  home-manager.users.aaron = {
    imports = [
      ./programs/mpv
      ./programs/librewolf
      ./programs/hyprland
    ];

    home.file."/.config/lsfg-vk/conf.toml" = {
      source = (pkgs.formats.toml { }).generate "lsfg-vk-configuration" {
        version = 1;
        global = {
          dll = losslessDll;
        };
        game = [
          {
            exe = "vkcube";
            multiplier = 4;
          }
          {
            exe = "retroarch";
            multiplier = 3;
          }
        ];
      };
    };

    accounts.email.accounts.aaron.thunderbird.enable = true;

    dconf.settings = {
      # connects virt-manager to qemu
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };

    fonts.fontconfig.enable = true;
  };
}
