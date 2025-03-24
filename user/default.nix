{
  imports = [ ./aaron ];

  users.groups = {
    media = { };
  };

  home-manager = {
    backupFileExtension = "backup";
    sharedModules = [
      {
        programs.neovim = {
          enable = true;
          defaultEditor = true;
          viAlias = true;
          vimAlias = true;
        };
      }
    ];
  };
}
