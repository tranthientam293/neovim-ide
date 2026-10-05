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

-- Bufferline: VSCode-like tabs ---------------------------------------------------
require('bufferline').setup({
  options = {
    close_command = function(bufnr) Snacks.bufdelete(bufnr) end,
    right_mouse_command = function(bufnr) Snacks.bufdelete(bufnr) end,
    diagnostics = 'nvim_lsp',
    diagnostics_indicator = function(_, _, diag)
      local icons = require('core.icons').diagnostics
      local s = {}
      if diag.error then table.insert(s, icons.ERROR .. diag.error) end
      if diag.warning then table.insert(s, icons.WARN .. diag.warning) end
      return table.concat(s, ' ')
    end,
    offsets = {
      { filetype = 'snacks_layout_box', text = 'Explorer', highlight = 'Directory', separator = true },
    },
    always_show_bufferline = true,
  },
})

map('n', '<Tab>', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next buffer' })
map('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Previous buffer' })
map('n', '<leader>bp', '<cmd>BufferLinePick<cr>', { desc = 'Pick buffer' })
map('n', '<leader>bo', function() Snacks.bufdelete.other() end, { desc = 'Close other buffers' })
map('n', '<leader>bP', '<cmd>BufferLineTogglePin<cr>', { desc = 'Pin buffer' })
for i = 1, 9 do -- Alt+1..9 jumps to tab N (VSCode: Ctrl+1..9)
  map('n', '<A-' .. i .. '>', '<cmd>BufferLineGoToBuffer ' .. i .. '<cr>', { desc = 'Go to buffer ' .. i })
end

-- Which-key: shows available keymaps after pressing <leader> --------------------------
local wk = require('which-key')
wk.setup({ preset = 'modern' })
wk.add({
  { '<leader>b', group = 'buffer' },
  { '<leader>c', group = 'code' },
  { '<leader>d', group = 'diagnostics' },
  { '<leader>f', group = 'find' },
  { '<leader>g', group = 'git' },
  { '<leader>s', group = 'split/session' },
  { '<leader>t', group = 'tab/toggle' },
})
