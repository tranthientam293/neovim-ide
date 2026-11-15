-- JavaScript / TypeScript (and the files that usually live next to them)
--
-- Tools follow the project's own setup (see lua/core/project.lua):
--   Linting    ESLint / Biome / Oxlint attach only where the project configures them;
--              with none configured, Oxlint runs with its default rules (after/lsp/oxlint.lua).
--   Formatting oxfmt or Biome when the project is configured for one (and it's installed),
--              otherwise prettierd / prettier.
local project = require('core.project')

local prettier = { 'prettierd', 'prettier', stop_after_first = true }

-- Formatters that can replace prettier, by the filetypes they handle
local alternatives = {
  { name = 'oxfmt', filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'json', 'jsonc' } },
  {
    name = 'biome',
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'json', 'jsonc', 'css' },
  },
}

local function formatter_for(ft)
  local candidates = vim.tbl_filter(function(alt)
    return vim.tbl_contains(alt.filetypes, ft)
  end, alternatives)

  return function(bufnr)
    for _, alt in ipairs(candidates) do
      if project.uses(bufnr, alt.name) and require('conform').get_formatter_info(alt.name, bufnr).available then
        return { alt.name }
      end
    end
    return prettier
  end
end

local formatters = {}
for _, ft in ipairs({
  'javascript', 'javascriptreact', 'typescript', 'typescriptreact',
  'json', 'jsonc', 'css', 'scss', 'html', 'markdown', 'yaml',
}) do
  formatters[ft] = formatter_for(ft)
end

return {
  servers = {
    'vtsls', -- TypeScript server, the same tsserver wrapper VSCode uses
    'eslint', -- ESLint diagnostics + quick fixes (only in projects configured for ESLint)
    'biome', -- Biome diagnostics + quick fixes (only in projects configured for Biome)
    'oxlint', -- Oxlint diagnostics + quick fixes (project config, or default rules when no linter is set up)
  },
  formatters = formatters,
  tools = { 'prettierd' },
  parsers = {
    'javascript', 'typescript', 'tsx', 'jsdoc',
    'json', 'css', 'scss', 'html', 'markdown', 'markdown_inline', 'yaml',
  },
}
