-- Noice: only LSP hover docs and LSP progress. Notifications, the command line and messages use
-- Neovim's built-in UI. Loaded right after the first screen is drawn.
require('noice').setup({
  notify = { enabled = false }, -- no notification popups; vim.notify uses the built-in message area
  cmdline = { enabled = false }, -- built-in command line at the bottom
  messages = { enabled = false }, -- built-in message area (Noice re-enables cmdline if this is on)
  popupmenu = { enabled = false }, -- built-in completion menu for the command line
  presets = {
    lsp_doc_border = true, -- border on Noice's hover (K) popup, matching vim.o.winborder floats
  },
  lsp = {
    signature = { enabled = false }, -- blink.cmp already shows signature help
  },
  views = {
    -- LSP progress ("Loading workspace...") uses the mini view, whose default row (-1) assumes
    -- cmdheight=0. With the built-in command line it lands on lualine, so lift it one row above.
    mini = { position = { row = -2 } },
  },
})
