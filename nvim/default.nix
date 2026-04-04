{ wlib, pkgs, lib, ... }:
{
  imports = [ wlib.wrapperModules.neovim ];

  settings = {
    config_directory = ./.;
    aliases = [ "vim" "vi" ];
  };

  extraPackages = with pkgs; [
    nil
    nixfmt
    lua-language-server
    pyright
    python3Packages.black
    typescript-language-server
    prettier
    bash-language-server
  ];

  hosts.python3.nvim-host.enable = true;
  hosts.node.nvim-host.enable = true;

  # All plugins loaded at startup (non-lazy). Setup happens in init.lua.
  specs.plugins = with pkgs.vimPlugins; [
    catppuccin-nvim
    nvim-web-devicons
    nvim-treesitter.withAllGrammars
    nvim-lspconfig
    blink-cmp
    plenary-nvim
    telescope-nvim
    lualine-nvim
    gitsigns-nvim
    oil-nvim
    conform-nvim
    which-key-nvim
  ];
}
