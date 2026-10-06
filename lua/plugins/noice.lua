-- Noice: command line as a floating popup in the center of the screen, plus messages and
-- notifications (shown through Snacks notifier). Loaded right after the first screen is drawn.
require('noice').setup({
  presets = {
    bottom_search = true, -- / and ? stay at the bottom like the built-in search
    long_message_to_split = true, -- long messages open in a split instead of a popup
  },
  lsp = {
    signature = { enabled = false }, -- blink.cmp already shows signature help
  },
})

vim.keymap.set('n', '<leader>fm', '<cmd>Noice pick<cr>', { desc = 'Message history' })
