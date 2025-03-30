{ pkgs, lib, ... }:
{
  stylix.targets.neovim.enable = false;

  programs.neovim = {
    extraPackages = with pkgs; [
      nil
      nixfmt-rfc-style
      lua-language-server
    ];
    plugins = with pkgs.vimPlugins; [
      tokyonight-nvim
      nvim-lspconfig
    ];
    extraLuaConfig = lib.fileContents ./config/init.lua;
  };
}
