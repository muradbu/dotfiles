vim.loader.enable()

require("options")
require("keymaps")

-- ── Colorscheme ─────────────────────────────────────────────────────────
require("catppuccin").setup({
  flavour = "mocha",
  integrations = {
    treesitter = true,
    telescope = { enabled = true },
    gitsigns = true,
    which_key = true,
    native_lsp = { enabled = true },
  },
})
vim.cmd.colorscheme("catppuccin")

-- ── Treesitter ──────────────────────────────────────────────────────────
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local buf = args.buf
    local lang = vim.treesitter.language.get_lang(args.match)
    if lang and vim.treesitter.language.add(lang) then
      vim.treesitter.start(buf, lang)
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.o.foldlevel = 99
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- ── Completion ──────────────────────────────────────────────────────────
require("blink.cmp").setup({
  keymap = { preset = "default" },
  sources = { default = { "lsp", "path", "snippets", "buffer" } },
  completion = { documentation = { auto_show = true } },
})

-- ── LSP ─────────────────────────────────────────────────────────────────
local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.lsp.config("nil_ls", { capabilities = capabilities })
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = { Lua = { diagnostics = { globals = { "vim" } } } },
})
vim.lsp.config("pyright", { capabilities = capabilities })
vim.lsp.config("ts_ls", { capabilities = capabilities })
vim.lsp.config("bashls", { capabilities = capabilities })
vim.lsp.enable({ "nil_ls", "lua_ls", "pyright", "ts_ls", "bashls" })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
  end,
})

-- ── Telescope ───────────────────────────────────────────────────────────
require("telescope").setup({})
local t = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", t.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", t.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", t.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", t.help_tags, { desc = "Help tags" })
vim.keymap.set("n", "<leader>fd", t.diagnostics, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>fr", t.oldfiles, { desc = "Recent files" })

-- ── Statusline ──────────────────────────────────────────────────────────
require("lualine").setup({
  options = { theme = "catppuccin", globalstatus = true },
})

-- ── Git signs ───────────────────────────────────────────────────────────
require("gitsigns").setup({
  on_attach = function(bufnr)
    local gs = require("gitsigns")
    local opts = { buffer = bufnr }
    vim.keymap.set("n", "]c", gs.next_hunk, opts)
    vim.keymap.set("n", "[c", gs.prev_hunk, opts)
    vim.keymap.set("n", "<leader>hs", gs.stage_hunk, opts)
    vim.keymap.set("n", "<leader>hr", gs.reset_hunk, opts)
    vim.keymap.set("n", "<leader>hp", gs.preview_hunk, opts)
    vim.keymap.set("n", "<leader>hb", gs.blame_line, opts)
  end,
})

-- ── Oil (file explorer) ─────────────────────────────────────────────────
require("oil").setup({ view_options = { show_hidden = true } })
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- ── Formatting ──────────────────────────────────────────────────────────
require("conform").setup({
  format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
  formatters_by_ft = {
    nix = { "nixfmt" },
    python = { "black" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    json = { "prettier" },
    markdown = { "prettier" },
  },
})

-- ── Which-key ───────────────────────────────────────────────────────────
require("which-key").setup({})
require("which-key").add({
  { "<leader>f", group = "find" },
  { "<leader>h", group = "git hunks" },
  { "<leader>r", group = "refactor" },
  { "<leader>c", group = "code" },
})
