{ pkgs, lib, ... }:
{
  programs.neovim = {
    enable = true;
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
