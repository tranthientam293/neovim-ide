-- JavaScript / TypeScript (and the files that usually live next to them)
local prettier = { 'prettierd', 'prettier', stop_after_first = true }

return {
  servers = {
    'vtsls', -- TypeScript server, the same tsserver wrapper VSCode uses
    'eslint', -- ESLint diagnostics + quick fixes (vscode-eslint)
  },
  formatters = {
    javascript = prettier,
    javascriptreact = prettier,
    typescript = prettier,
    typescriptreact = prettier,
    json = prettier,
    jsonc = prettier,
    css = prettier,
    scss = prettier,
    html = prettier,
    markdown = prettier,
    yaml = prettier,
  },
  tools = { 'prettierd' },
  parsers = {
    'javascript', 'typescript', 'tsx', 'jsdoc',
    'json', 'css', 'scss', 'html', 'markdown', 'markdown_inline', 'yaml',
  },
}
