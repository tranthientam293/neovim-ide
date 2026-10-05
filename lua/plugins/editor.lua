-- Loaded when the first file is opened
local map = vim.keymap.set
local lazy = require('core.lazy')

-- Built-in `gc` commenting, made JSX/TSX aware
require('ts-comments').setup({})

-- Git gutter, hunks and inline blame (GitLens-like) --------------------------------
require('gitsigns').setup({
  current_line_blame = false,
  on_attach = function(bufnr)
    local gs = require('gitsigns')
    local bmap = function(mode, lhs, rhs, desc)
      map(mode, lhs, rhs, { buffer = bufnr, desc = 'Git: ' .. desc })
    end
    bmap('n', ']h', function() gs.nav_hunk('next') end, 'Next hunk')
    bmap('n', '[h', function() gs.nav_hunk('prev') end, 'Previous hunk')
    bmap('n', '<leader>gp', gs.preview_hunk, 'Preview hunk')
    bmap({ 'n', 'v' }, '<leader>gs', gs.stage_hunk, 'Stage hunk')
    bmap({ 'n', 'v' }, '<leader>gr', gs.reset_hunk, 'Reset hunk')
    bmap('n', '<leader>gb', gs.blame_line, 'Blame line')
    bmap('n', '<leader>gd', gs.diffthis, 'Diff against index')
    bmap('n', '<leader>tb', gs.toggle_current_line_blame, 'Toggle inline blame')
  end,
})

-- Problems panel (VSCode: Ctrl+Shift+M), set up on first :Trouble ---------------------
lazy.cmd('Trouble', function()
  require('trouble').setup({})
end)
map('n', '<leader>dp', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Problems (workspace)' })
map('n', '<leader>db', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Problems (buffer)' })
map('n', '<leader>ds', '<cmd>Trouble symbols toggle focus=false<cr>', { desc = 'Outline (symbols)' })
