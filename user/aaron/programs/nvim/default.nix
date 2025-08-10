{ pkgs, lib, ... }:
{
  stylix.targets.neovim.enable = false;

  programs.neovim = {
    extraPackages = with pkgs; [
      lua-language-server
      pyright
      nixd
      nushell # for the lsp, which doesn't work anyway
    ];
    plugins = with pkgs.vimPlugins; [
      Shade-nvim
      nvim-lspconfig
      nvim-treesitter
      (nvim-treesitter.withPlugins (_: [
        pkgs.tree-sitter.builtGrammars.tree-sitter-nu
      ]))
      tokyonight-nvim
      oil-nvim
    ];
    extraLuaConfig = lib.fileContents ./config/init.lua;
  };
}
