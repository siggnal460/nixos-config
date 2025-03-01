{
  users.users.aaron.extraGroups = [ "libvirtd" ];

  systemd.tmpfiles.rules = [ "d /home/aaron/projects 0700 aaron users" ];

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
