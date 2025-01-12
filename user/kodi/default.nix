{
  home-manager.users.kodi = {
    imports = [
      ./programs/kodi
      ./programs/gammastep
    ];

    home = {
      username = "kodi";
      homeDirectory = "/home/kodi";
      stateVersion = "23.11";
    };
  };
}
