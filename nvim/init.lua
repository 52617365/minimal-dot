vim.g.mapleader = ";"
vim.cmd("set clipboard=unnamedplus")
vim.cmd("set nowrap")
vim.cmd("set noswapfile")
vim.cmd("set backupdir=~/.config/nvim/backup/")
vim.opt.ignorecase = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.number = true
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

plugins = {
  {'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' }},
  {'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
  {"numToStr/Comment.nvim"},
  {"neovim/nvim-lspconfig"},
  {"EdenEast/nightfox.nvim"},
  {
    'smoka7/hop.nvim',
    version = "*",
    opts = {
        keys = 'etovxqpdygfblzhckisuran'
    }
  },
  {'tpope/vim-fugitive'},
  {'kylechui/nvim-surround', version = "*"},
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  },
  M,
}

-- Auto formatting and go imports when saving with *.go files using ray-x/go.nvim
local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
    -- machine and codebase, you may want longer. Add an additional
    -- argument after params if you find that you have to write the file
    -- twice for changes to be saved.
    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({async = false})
  end
})
--

-- Getting rid of the fucking annoying symbols in the line number space with diagnostics.
-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#change-prefixcharacter-preceding-the-diagnostics-virtual-text
for _, diag in ipairs({ "Error", "Warn", "Info", "Hint" }) do
    vim.fn.sign_define("DiagnosticSign" .. diag, {
        text = "",
        texthl = "DiagnosticSign" .. diag,
        linehl = "",
        numhl = "DiagnosticSign" .. diag,
    })
end

require("lazy").setup(plugins)
require('telescope').setup{
  pickers = {
    find_files = {
      theme = "ivy",
      layout_config = {
        height = 0.5,
      },
    },
    live_grep = {
      theme = "ivy",
      layout_config = {
        height = 0.5,
      },
    },
    grep_string = {
      theme = "ivy",
      layout_config = {
        height = 0.5,
      },
    },
    diagnostics = {
      theme = "ivy",
      layout_config = {
        height = 0.5,
      },
    },
  },
  extensions = {
    fzf = {
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
    }
  }
}
require('nvim-surround').setup({})


local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
vim.keymap.set('n', '<leader>s', builtin.grep_string, {})
vim.keymap.set('n', '<leader>d', builtin.diagnostics, {})

require('hop')
vim.keymap.set('n', '<leader>h', ":HopWord<CR>", { silent = true })

require('Comment').setup()

local on_attach = function(client)
    require'completion'.on_attach(client)
end

local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup {}
lspconfig.pyright.setup {}
lspconfig.gopls.setup {}
lspconfig.ansiblels.setup {}
lspconfig.gopls.setup({
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
})

vim.cmd("colorscheme carbonfox")

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
      local opts = {buffer = ev.buf}

      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
      vim.keymap.set('n', '<leader>u', builtin.lsp_references, opts)
      vim.keymap.set({ 'n', 'v' }, '<leader>c', vim.lsp.buf.code_action, opts)
   end,
})

