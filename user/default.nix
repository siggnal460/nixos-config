{
  imports = [ ./aaron ];

  users.groups = {
    media = { };
  };

  home-manager = {
    backupFileExtension = "hmbackup";
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
