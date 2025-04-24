{ ... }: 

{
  programs.nixvim = {
    enable = true;
    globalOpts = {
      number = true;
      relativenumber = true;
      termguicolors = true;
      completeopt = [ "menuone" "noselect" "noinsert" ];
      ignorecase = true;
      smartcase = true;
    };
    colorschemes.ayu.enable = true;
    plugins = {
      nix.enable = true;
      neoscroll = {
        enable = true;
        autoLoad = true;
        settings = {
          cursor_scrolls_alone = true;
          easing_function = "quadratic";
          hide_cursor = true;
          mappings = [
            "<C-u>"
            "<C-d>"
            "<C-b>"
            "<C-f>"
            "<C-y>"
            "<C-e>"
            "zt"
            "zz"
            "zb"
          ];
          respect_scrolloff = false;
          stop_eof = true;
        };
      };
      lualine.enable = true;
      numbertoggle.enable = true;
      treesitter = {
        enable = true;
	settings = {
          highlight.enable = true;
	};
      };
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          preselect = "cmp.PreselectMode.Item";
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
        };
      };
      lsp = {
        enable = true;
        servers.nixd.enable = true;
        servers.ts_ls.enable = true;
        servers.bashls.enable = true;
      };
    };
  };
}
