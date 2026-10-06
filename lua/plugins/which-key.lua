-- Which-key: shows available keymaps after pressing <leader> (loaded right after the first screen is drawn)
local wk = require('which-key')
wk.setup({ preset = 'modern' })
wk.add({
  { '<leader>b', group = 'buffer' },
  { '<leader>c', group = 'code' },
  { '<leader>d', group = 'diagnostics' },
  { '<leader>f', group = 'find' },
  { '<leader>g', group = 'git' },
  { '<leader>m', group = 'markdown' },
  { '<leader>s', group = 'split/session' },
  { '<leader>t', group = 'tab/toggle' },
})
