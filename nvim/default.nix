{ wlib, pkgs, lib, ... }:
{
  imports = [ wlib.wrapperModules.neovim ];

  enable = true;
  binName = "nvim";

  settings = {
    config_directory = ./.;
    aliases = [ "vim" "vi" ];
  };

  extraPackages = with pkgs; [
    # Nix
    nil
    nixfmt-rfc-style
    # Lua
    lua-language-server
    # Python
    pyright
    python3Packages.black
    # JS/TS
    nodePackages.typescript-language-server
    nodePackages.prettier
    # Shell
    bash-language-server
  ];

  hosts.python3.nvim-host.enable = true;
  hosts.node.nvim-host.enable = true;

  specs = {
    # ── Colorscheme ──────────────────────────────────────────────────────
    catppuccin = {
      data = pkgs.vimPlugins.catppuccin-nvim;
      config = ''
        require("catppuccin").setup({ flavour = "mocha", integrations = {
          treesitter = true, telescope = { enabled = true }, gitsigns = true,
          which_key = true, cmp = true, native_lsp = { enabled = true },
        }})
        vim.cmd.colorscheme("catppuccin")
      '';
    };

    # ── Icons ─────────────────────────────────────────────────────────────
    devicons = pkgs.vimPlugins.nvim-web-devicons;

    # ── Treesitter ────────────────────────────────────────────────────────
    treesitter = {
      data = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
      config = ''
        require("nvim-treesitter.configs").setup({
          highlight = { enable = true },
          indent = { enable = true },
        })
      '';
    };

    # ── LSP ───────────────────────────────────────────────────────────────
    lspconfig = {
      data = pkgs.vimPlugins.nvim-lspconfig;
      after = [ "treesitter" "blink-cmp" ];
      config = ''
        local lsp = require("lspconfig")
        local capabilities = require("blink.cmp").get_lsp_capabilities()

        lsp.nil_ls.setup({ capabilities = capabilities })
        lsp.lua_ls.setup({
          capabilities = capabilities,
          settings = { Lua = { diagnostics = { globals = { "vim" } } } },
        })
        lsp.pyright.setup({ capabilities = capabilities })
        lsp.ts_ls.setup({ capabilities = capabilities })
        lsp.bashls.setup({ capabilities = capabilities })

        -- Keymaps on attach
        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(ev)
            local opts = { buffer = ev.buf }
            vim.keymap.set("n", "gd",         vim.lsp.buf.definition,    opts)
            vim.keymap.set("n", "gD",         vim.lsp.buf.declaration,   opts)
            vim.keymap.set("n", "gr",         vim.lsp.buf.references,    opts)
            vim.keymap.set("n", "gi",         vim.lsp.buf.implementation, opts)
            vim.keymap.set("n", "K",          vim.lsp.buf.hover,         opts)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,        opts)
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,   opts)
            vim.keymap.set("n", "[d",         vim.diagnostic.goto_prev,  opts)
            vim.keymap.set("n", "]d",         vim.diagnostic.goto_next,  opts)
            vim.keymap.set("n", "<leader>e",  vim.diagnostic.open_float, opts)
          end,
        })
      '';
    };

    # ── Completion ────────────────────────────────────────────────────────
    "blink-cmp" = {
      data = pkgs.vimPlugins.blink-cmp;
      config = ''
        require("blink.cmp").setup({
          keymap = { preset = "default" },
          sources = { default = { "lsp", "path", "snippets", "buffer" } },
          completion = { documentation = { auto_show = true } },
        })
      '';
    };

    # ── Telescope ─────────────────────────────────────────────────────────
    plenary = pkgs.vimPlugins.plenary-nvim;
    telescope = {
      data = pkgs.vimPlugins.telescope-nvim;
      after = [ "plenary" "devicons" ];
      config = ''
        require("telescope").setup({})
        local t = require("telescope.builtin")
        vim.keymap.set("n", "<leader>ff", t.find_files,  { desc = "Find files" })
        vim.keymap.set("n", "<leader>fg", t.live_grep,   { desc = "Live grep" })
        vim.keymap.set("n", "<leader>fb", t.buffers,     { desc = "Buffers" })
        vim.keymap.set("n", "<leader>fh", t.help_tags,   { desc = "Help tags" })
        vim.keymap.set("n", "<leader>fd", t.diagnostics, { desc = "Diagnostics" })
        vim.keymap.set("n", "<leader>fr", t.oldfiles,    { desc = "Recent files" })
      '';
    };

    # ── Statusline ────────────────────────────────────────────────────────
    lualine = {
      data = pkgs.vimPlugins.lualine-nvim;
      after = [ "catppuccin" "devicons" ];
      config = ''
        require("lualine").setup({
          options = { theme = "catppuccin", globalstatus = true },
        })
      '';
    };

    # ── Git ───────────────────────────────────────────────────────────────
    gitsigns = {
      data = pkgs.vimPlugins.gitsigns-nvim;
      config = ''
        require("gitsigns").setup({
          on_attach = function(bufnr)
            local gs = require("gitsigns")
            local opts = { buffer = bufnr }
            vim.keymap.set("n", "]c", gs.next_hunk,        opts)
            vim.keymap.set("n", "[c", gs.prev_hunk,        opts)
            vim.keymap.set("n", "<leader>hs", gs.stage_hunk,   opts)
            vim.keymap.set("n", "<leader>hr", gs.reset_hunk,   opts)
            vim.keymap.set("n", "<leader>hp", gs.preview_hunk, opts)
            vim.keymap.set("n", "<leader>hb", gs.blame_line,   opts)
          end,
        })
      '';
    };

    # ── File explorer ─────────────────────────────────────────────────────
    oil = {
      data = pkgs.vimPlugins.oil-nvim;
      after = [ "devicons" ];
      config = ''
        require("oil").setup({ view_options = { show_hidden = true } })
        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      '';
    };

    # ── Formatting ────────────────────────────────────────────────────────
    conform = {
      data = pkgs.vimPlugins.conform-nvim;
      config = ''
        require("conform").setup({
          format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
          formatters_by_ft = {
            nix        = { "nixfmt" },
            python     = { "black" },
            javascript = { "prettier" },
            typescript = { "prettier" },
            json       = { "prettier" },
            markdown   = { "prettier" },
          },
        })
      '';
    };

    # ── Keybinding hints ─────────────────────────────────────────────────
    which-key = {
      data = pkgs.vimPlugins.which-key-nvim;
      config = ''
        require("which-key").setup({})
        require("which-key").add({
          { "<leader>f", group = "find" },
          { "<leader>h", group = "git hunks" },
          { "<leader>r", group = "refactor" },
          { "<leader>c", group = "code" },
        })
      '';
    };
  };
}
