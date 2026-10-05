local conform = require('conform')

-- Formatting is manual only (no format on save)
conform.setup({
  formatters_by_ft = require('langs').formatters,
  -- Filetypes without a configured formatter fall back to the LSP's formatter
  default_format_opts = { lsp_format = 'fallback' },
})

-- Use conform for `gq` too
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

local format = function()
  conform.format({ async = true })
end
vim.keymap.set({ 'n', 'v' }, '<leader>cf', format, { desc = 'Format buffer/selection' })
vim.keymap.set({ 'n', 'v' }, '<S-A-f>', format, { desc = 'Format buffer/selection' }) -- VSCode: Shift+Alt+F
