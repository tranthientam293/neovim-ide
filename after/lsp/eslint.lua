-- Merged on top of nvim-lspconfig's lsp/eslint.lua
-- Keep lspconfig's on_attach (it defines :LspEslintFixAll) and add a keymap on top.
local base = vim.api.nvim_get_runtime_file('lsp/eslint.lua', false)[1]
local base_on_attach = base and dofile(base).on_attach

return {
  settings = {
    format = false, -- formatting is done by prettier (conform.nvim)
  },
  on_attach = function(client, bufnr)
    if base_on_attach then
      base_on_attach(client, bufnr)
    end
    vim.keymap.set('n', '<leader>ce', '<cmd>LspEslintFixAll<cr>', { buffer = bufnr, desc = 'ESLint: Fix all' })
  end,
}
