local map = vim.keymap.set

-- Snacks: file picker, explorer sidebar, terminal, indent guides, notifications --------
require('snacks').setup({
  bigfile = { enabled = true },
  quickfile = { enabled = true },
  indent = {
    enabled = true,
    indent = { char = '▏' }, -- thin line on the left edge of the cell (U+258F)
    scope = { char = '▏' },
  },
  input = { enabled = true },
  notifier = {
    enabled = true,
    -- Extra space after each icon: Nerd Font glyphs are wider than one cell in
    -- Windows Terminal and get clipped by the next character otherwise.
    icons = {
      error = '  ',
      warn = '  ',
      info = '  ',
      debug = '  ',
      trace = '  ',
    },
  },
  explorer = { enabled = true, replace_netrw = true },
  terminal = { enabled = true },
  picker = {
    enabled = true,
    sources = {
      files = { hidden = true }, -- show dotfiles, respect .gitignore
      grep = { hidden = true },
      explorer = { hidden = true, ignored = true }, -- like VSCode: show everything, gitignored files dimmed
    },
  },
})

local picker = function(name, opts)
  return function()
    Snacks.picker[name](opts)
  end
end

-- VSCode: Ctrl+P (quick open), Ctrl+B (sidebar), Ctrl+` (terminal)
map('n', '<C-p>', picker('files'), { desc = 'Find files' })
map('n', '<C-b>', function() Snacks.explorer() end, { desc = 'Toggle file explorer' })
map('n', '<leader>e', function() Snacks.explorer() end, { desc = 'Toggle file explorer' })
map({ 'n', 't' }, '<C-`>', function() Snacks.terminal() end, { desc = 'Toggle terminal' })
map('n', '<leader>tt', function() Snacks.terminal() end, { desc = 'Toggle terminal' })

map('n', '<leader><space>', picker('smart'), { desc = 'Smart find files' })
map('n', '<leader>ff', picker('files'), { desc = 'Find files' })
map('n', '<leader>fg', picker('grep'), { desc = 'Search in files (grep)' })
map({ 'n', 'x' }, '<leader>fw', picker('grep_word'), { desc = 'Search word/selection' })
map('n', '<leader>fb', picker('buffers'), { desc = 'Find buffers' })
map('n', '<leader>fr', picker('recent'), { desc = 'Recent files' })
map('n', '<leader>fc', picker('commands'), { desc = 'Command palette' })
map('n', '<leader>fk', picker('keymaps'), { desc = 'Keymaps' })
map('n', '<leader>fh', picker('help'), { desc = 'Help pages' })
map('n', '<leader>f/', picker('lines'), { desc = 'Search in buffer' })
map('n', '<leader>fR', picker('resume'), { desc = 'Resume last search' })
map('n', '<leader>fn', function() Snacks.notifier.show_history() end, { desc = 'Notification history' })
