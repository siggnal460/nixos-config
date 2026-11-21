{ lib, ... }:
{
  home-manager = {
    backupFileExtension = "hmbackup";
    sharedModules = [
      (
        { config, ... }:
        {
          programs.neovim = {
            enable = true;
            defaultEditor = true;
            viAlias = true;
            vimAlias = true;
            withRuby = true;
            withPython3 = true;
          };

          gtk.gtk4.theme = lib.mkDefault config.gtk.theme;

          stylix.enableReleaseChecks = false;
        }
      )
    ];
  };
}
