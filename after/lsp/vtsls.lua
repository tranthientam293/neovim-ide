-- Merged on top of nvim-lspconfig's lsp/vtsls.lua
-- Settings mirror VSCode's `typescript.*` / `javascript.*` settings.
local lang_settings = {
  updateImportsOnFileMove = { enabled = 'always' },
  suggest = { completeFunctionCalls = true },
  preferences = { importModuleSpecifier = 'shortest' },
  inlayHints = {
    parameterNames = { enabled = 'literals' },
    parameterTypes = { enabled = true },
    variableTypes = { enabled = false },
    propertyDeclarationTypes = { enabled = true },
    functionLikeReturnTypes = { enabled = true },
    enumMemberValues = { enabled = true },
  },
}

---@param kind string
local function source_action(kind)
  return function()
    vim.lsp.buf.code_action({
      apply = true,
      context = { only = { kind }, diagnostics = {} },
      filter = function(_, client_id)
        return vim.lsp.get_client_by_id(client_id).name == 'vtsls'
      end,
    })
  end
end

return {
  settings = {
    complete_function_calls = true,
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true, -- use the project's node_modules/typescript
      experimental = {
        completion = { enableServerSideFuzzyMatch = true },
      },
    },
    typescript = lang_settings,
    javascript = lang_settings,
  },
  on_attach = function(client, bufnr)
    local map = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = bufnr, desc = 'TS: ' .. desc })
    end
    map('<leader>co', source_action('source.organizeImports'), 'Organize imports')
    map('<leader>cM', source_action('source.addMissingImports.ts'), 'Add missing imports')
    map('<leader>cu', source_action('source.removeUnused.ts'), 'Remove unused')
    map('<leader>cF', source_action('source.fixAll.ts'), 'Fix all (TS)')
    map('gS', function()
      client:exec_cmd({
        title = 'Go to source definition',
        command = 'typescript.goToSourceDefinition',
        arguments = { vim.uri_from_bufnr(bufnr), vim.lsp.util.make_position_params(0, client.offset_encoding).position },
      }, { bufnr = bufnr }, function(err, result)
        if err or not result or vim.tbl_isempty(result) then
          vim.notify('No source definition found', vim.log.levels.INFO)
          return
        end
        vim.lsp.util.show_document(result[1], client.offset_encoding, { focus = true })
      end)
    end, 'Go to source definition')
    map('<leader>cV', function()
      client:exec_cmd({ title = 'Select TS version', command = 'typescript.selectTypeScriptVersion' }, { bufnr = bufnr })
    end, 'Select TypeScript version')
  end,
}
