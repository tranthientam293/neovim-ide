vim.pack.add({
  -- UI
  { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
  'https://github.com/folke/tokyonight.nvim',
  'https://github.com/rebelot/kanagawa.nvim',
  'https://github.com/ellisonleao/gruvbox.nvim',
  'https://github.com/craftzdog/solarized-osaka.nvim',
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/akinsho/bufferline.nvim',
  'https://github.com/folke/which-key.nvim',
  'https://github.com/folke/snacks.nvim', -- picker, explorer, terminal, indent guides, notifications

  -- Syntax (treesitter)
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  'https://github.com/nvim-treesitter/nvim-treesitter-context', -- sticky scroll
  'https://github.com/windwp/nvim-ts-autotag', -- auto close/rename JSX/HTML tags

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

  -- Completion (version tag needed so blink can download its prebuilt fuzzy matcher)
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.*') },
  'https://github.com/rafamadriz/friendly-snippets',

  -- Formatting & linting
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/mfussenegger/nvim-lint',
})

require('plugins.colorscheme')
require('plugins.ui')
require('plugins.statusline')
require('plugins.treesitter')
require('plugins.editor')
require('plugins.completion')
require('plugins.lsp')
require('plugins.format')
require('plugins.lint')
