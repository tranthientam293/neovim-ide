vim.pack.add({
  -- UI
  { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/akinsho/bufferline.nvim',
  'https://github.com/folke/which-key.nvim',
  'https://github.com/folke/snacks.nvim', -- picker, explorer, terminal, indent guides, notifications
  'https://github.com/folke/noice.nvim', -- floating command line, messages
  'https://github.com/MunifTanjim/nui.nvim', -- UI components used by noice

  -- Syntax (treesitter)
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  'https://github.com/nvim-treesitter/nvim-treesitter-context', -- sticky scroll

  -- Editing
  'https://github.com/windwp/nvim-autopairs',
  'https://github.com/folke/ts-comments.nvim', -- correct comments in JSX/TSX
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/folke/trouble.nvim', -- problems panel

  -- LSP
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',

  -- Formatting & linting
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/mfussenegger/nvim-lint',
})

-- Installed but not loaded: their plugin/ files are slow at startup, so the module that first
-- needs each one `:packadd`s it via core.lazy.packadd().
vim.pack.add({
  -- Completion (version tag needed so blink can download its prebuilt fuzzy matcher)
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.*') }, -- plugins/lsp.lua
  'https://github.com/rafamadriz/friendly-snippets', -- plugins/completion.lua
  'https://github.com/windwp/nvim-ts-autotag', -- plugins/treesitter.lua: auto close/rename JSX/HTML tags
  'https://github.com/MeanderingProgrammer/render-markdown.nvim', -- plugins/markdown.lua
}, { load = function() end })

-- Plugins in the first list are on the runtimepath now; their setup is spread over startup so the first screen
-- only waits for what it shows. See docs/plugins.md#load-order.
local lazy = require('core.lazy')

-- 1. Needed for the first screen
require('plugins.colorscheme')
require('plugins.ui') -- snacks: picker, explorer, quickfile, notifications

-- 2. Right after the first screen is drawn. Reserve their lines now so the layout doesn't jump.
vim.o.laststatus = 3
vim.o.statusline = ' '
vim.o.showtabline = 2
vim.o.tabline = ' '
lazy.after_ui('plugins.statusline')
lazy.after_ui('plugins.bufferline')
lazy.after_ui('plugins.which-key')
lazy.after_ui('plugins.noice')

-- 3. When the first file is opened (BufReadPre fires for `nvim file` too, so nothing is missed)
local load_file_plugins = lazy.once(function()
  require('plugins.treesitter')
  require('plugins.lsp')
  require('plugins.format')
  require('plugins.lint')
  require('plugins.editor')
end)
lazy.on({ 'BufReadPre', 'BufNewFile' }, load_file_plugins)
lazy.cmd('Mason', load_file_plugins)

-- 4. On first insert / command line
lazy.on({ 'InsertEnter', 'CmdlineEnter' }, 'plugins.completion')

-- 5. On the first markdown buffer
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  once = true,
  callback = function()
    require('plugins.markdown')
  end,
})
