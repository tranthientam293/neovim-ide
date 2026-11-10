-- Merged on top of nvim-lspconfig's lsp/gopls.lua
-- Settings mirror VSCode Go's `gopls` settings. Formatting is done by conform (goimports + gofumpt).

---@param kind string
local function source_action(kind)
  return function()
    vim.lsp.buf.code_action({
      apply = true,
      context = { only = { kind }, diagnostics = {} },
      filter = function(_, client_id)
        return vim.lsp.get_client_by_id(client_id).name == 'gopls'
      end,
    })
  end
end

return {
  settings = {
    gopls = {
      gofumpt = true, -- keep gopls' own formatting/code actions consistent with conform's gofumpt
      usePlaceholders = true, -- fill function call parameters on completion
      completeUnimported = true,
      staticcheck = true,
      semanticTokens = true,
      directoryFilters = { '-.git', '-.vscode', '-.idea', '-node_modules' },
      analyses = {
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
        shadow = true,
      },
      codelenses = {
        generate = true,
        gc_details = false,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
  on_attach = function(_, bufnr)
    vim.keymap.set('n', '<leader>co', source_action('source.organizeImports'), {
      buffer = bufnr,
      desc = 'Go: Organize imports',
    })
  end,
}
