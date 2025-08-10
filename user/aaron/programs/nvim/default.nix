{ pkgs, lib, ... }:
{
  stylix.targets.neovim.enable = false;

  programs.neovim = {
    extraPackages = with pkgs; [
      lua-language-server
			pyright
			nixd
    ];
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      tokyonight-nvim
      oil-nvim
    ];
    extraLuaConfig = lib.fileContents ./config/init.lua;
  };
}
