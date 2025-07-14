{ pkgs, lib, ... }:
{
  stylix.targets.neovim.enable = false;

  programs.neovim = {
    extraPackages = with pkgs; [
      lua-language-server
    ];
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
			tokyonight-nvim
    ];
    extraLuaConfig = lib.fileContents ./config/init.lua;
  };
}
