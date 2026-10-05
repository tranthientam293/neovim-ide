local map = vim.keymap.set

-- Bufferline: VSCode-like tabs (loaded right after the first screen is drawn)
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
