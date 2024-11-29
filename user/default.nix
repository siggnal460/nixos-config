{
  imports = [ ./aaron ];

  users.groups = {
    media = { };
  };

  home-manager = {
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
