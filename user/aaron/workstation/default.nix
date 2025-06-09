{
  users.users.aaron.extraGroups = [ "libvirtd" ];

  systemd = {
    tmpfiles.rules = [
      "d /home/aaron/Blender 0700 aaron aaron"
      "d /home/aaron/Blender/addons 0700 aaron aaron"
      "d /home/aaron/Blender/models 0700 aaron aaron"
      "d /home/aaron/Blender/models/male 0700 aaron aaron"
      "d /home/aaron/Blender/models/female 0700 aaron aaron"
      "d /home/aaron/Blender/models/objects 0700 aaron aaron"
      "d /home/aaron/Blender/environments 0700 aaron aaron"
      "d /home/aaron/Projects 0700 aaron aaron"
      "d /home/aaron/Games 0700 aaron aaron"
      "d /home/aaron/Games/2ds 0700 aaron aaron"
      "d /home/aaron/Games/3ds 0700 aaron aaron"
      "d /home/aaron/Games/gb 0700 aaron aaron"
      "d /home/aaron/Games/gbc 0700 aaron aaron"
      "d /home/aaron/Games/gba 0700 aaron aaron"
      "d /home/aaron/Games/gc 0700 aaron aaron"
      "d /home/aaron/Games/n64 0700 aaron aaron"
      "d /home/aaron/Games/nes 0700 aaron aaron"
      "d /home/aaron/Games/ps1 0700 aaron aaron"
      "d /home/aaron/Games/ps2 0700 aaron aaron"
      "d /home/aaron/Games/ps3 0700 aaron aaron"
      "d /home/aaron/Games/psp 0700 aaron aaron"
      "d /home/aaron/Games/snes 0700 aaron aaron"
      "d /home/aaron/Games/wii 0700 aaron aaron"
      "d /home/aaron/Games/wiiu 0700 aaron aaron"
    ];
  };

  home-manager.users.aaron = {
    imports = [
      ./programs/mpv
      ./programs/librewolf
    ];

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
