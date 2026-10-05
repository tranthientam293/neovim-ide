local icons = require('core.icons').diagnostics

require('lualine').setup({
  options = {
    theme = 'auto', -- follows the active colorscheme
    globalstatus = true, -- one statusline for all windows (like VSCode)
    section_separators = { left = '', right = '' }, -- solid powerline triangles
    component_separators = { left = '', right = '' }, -- thin powerline angles
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff' },
    lualine_c = {
      { 'filename', path = 1 }, -- relative path
      {
        'diagnostics',
        symbols = { error = icons.ERROR, warn = icons.WARN, info = icons.INFO, hint = icons.HINT },
      },
    },
    lualine_x = {
      {
        'lsp_status',
        icon = ' ', -- nf-fa-cogs
        symbols = { done = '', separator = ' ' }, -- nf-fa-check
      },
      'filetype',
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
})

vim.o.showmode = false -- mode is shown in lualine
