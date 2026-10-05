-- Extra (non-LSP) linters. JS/TS linting is handled by the eslint language server,
-- so this only runs linters declared in lua/langs/*.lua `linters`.
local lint = require('lint')

lint.linters_by_ft = require('langs').linters

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost', 'InsertLeave' }, {
  group = vim.api.nvim_create_augroup('user_lint', { clear = true }),
  callback = function()
    lint.try_lint()
  end,
})
