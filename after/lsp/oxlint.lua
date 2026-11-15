-- Merged on top of nvim-lspconfig's lsp/oxlint.lua
--
-- Oxlint is the default JS/TS linter:
-- * project configured for oxlint (.oxlintrc.json(c) / oxlint.config.ts / oxlint in package.json)
--     -> attach at that config's directory (lspconfig's own detection)
-- * project configured for ESLint or Biome instead -> don't attach, that linter takes over
-- * no linter configured at all -> attach at the project root with oxlint's built-in default rules
--
-- Keep lspconfig's on_attach (it defines :LspOxlintFixAll) and add a keymap on top.
local project = require('core.project')

local base_file = vim.api.nvim_get_runtime_file('lsp/oxlint.lua', false)[1]
local base = base_file and dofile(base_file) or {}

return {
  root_dir = function(bufnr, on_dir)
    if project.uses(bufnr, 'oxlint') then
      local root
      if base.root_dir then
        base.root_dir(bufnr, function(dir)
          root = dir
        end)
      end
      return on_dir(root or project.root(bufnr))
    end
    if project.uses(bufnr, 'eslint') or project.uses(bufnr, 'biome') then
      return -- the project's own linter handles this buffer
    end
    on_dir(project.root(bufnr))
  end,
  on_attach = function(client, bufnr)
    if base.on_attach then
      base.on_attach(client, bufnr)
    end
    vim.keymap.set('n', '<leader>cx', '<cmd>LspOxlintFixAll<cr>', { buffer = bufnr, desc = 'Oxlint: Fix all' })
  end,
}
