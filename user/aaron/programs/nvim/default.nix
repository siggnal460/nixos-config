{ pkgs, lib, ... }:
{
  stylix.targets.neovim.enable = false;

  programs.neovim = {
    extraPackages = with pkgs; [
      lua-language-server
      pyright
      nixd
      nushell # for the lsp, which doesn't work anyway
      nodePackages.vscode-langservers-extracted
    ];
    plugins = with pkgs.vimPlugins; [
      nvim-scrollbar
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
