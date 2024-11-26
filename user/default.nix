{
  imports = [ ./aaron ];

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
