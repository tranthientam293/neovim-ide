# LSP & Languages

Language support is **data-driven**: each file in `lua/langs/` describes one language, and the LSP,
formatter, linter and treesitter modules read the merged result.

```
lua/langs/*.lua ──► langs/init.lua (merge) ──┬─► plugins/lsp.lua         servers + tools → Mason, vim.lsp.enable
                                             ├─► plugins/format.lua      formatters      → conform.nvim
                                             ├─► plugins/lint.lua        linters         → nvim-lint
                                             └─► plugins/treesitter.lua  parsers         → nvim-treesitter
after/lsp/<server>.lua ──► per-server settings, merged on top of nvim-lspconfig's lsp/<server>.lua
```

## Language spec format

```lua
-- lua/langs/<name>.lua
return {
  servers    = { 'vtsls' },                       -- LSP names (as named by nvim-lspconfig)
  formatters = { typescript = { 'prettierd' } },  -- conform.nvim formatters_by_ft
  linters    = { sh = { 'shellcheck' } },         -- nvim-lint linters_by_ft (non-LSP linters only)
  tools      = { 'prettierd' },                   -- extra Mason packages to auto-install
  parsers    = { 'typescript', 'tsx' },           -- treesitter parsers
}
```

`langs/init.lua` scans the folder, `require`s each file (errors are reported with `vim.notify` but
don't break startup), concatenates lists (deduplicated and sorted) and merges the `formatters` /
`linters` tables (a later file wins on a filetype conflict).

## Configured languages

### Lua — `langs/lua.lua`

| Kind | Value |
| --- | --- |
| Server | `lua_ls` |
| Formatter | `stylua` (rules in `.stylua.toml`: 2 spaces, 120 cols, single quotes, always parentheses) |
| Parsers | `lua`, `luadoc` |

`after/lsp/lua_ls.lua`:
- Root markers, in priority order: `.emmyrc.json`/`.luarc.json(c)` → `.luacheckrc`/`stylua.toml`/`selene.*` → `.git`.
- Inlay hints enabled server-side (but shown only after `<leader>th`), no semicolon hints.
- Codelens disabled.
- `vim` and `Snacks` declared as globals so they don't raise "undefined global".

### JavaScript / TypeScript — `langs/typescript.lua`

| Kind | Value |
| --- | --- |
| Servers | `vtsls` (the tsserver wrapper VSCode uses), `eslint` (vscode-eslint) |
| Formatter | `prettierd`, falling back to `prettier` — for JS, JSX, TS, TSX, JSON(C), CSS, SCSS, HTML, Markdown, YAML |
| Tools | `prettierd` |
| Parsers | `javascript`, `typescript`, `tsx`, `jsdoc`, `json`, `css`, `scss`, `html`, `markdown`, `markdown_inline`, `yaml` |

`after/lsp/vtsls.lua` mirrors VSCode's `typescript.*` / `javascript.*` settings:
- Update imports on file move: always.
- Complete function calls with parameter placeholders.
- Import specifier: shortest path.
- Inlay hints: parameter names (literals only), parameter types, property declaration types, return
  types, enum values (variable types off).
- `autoUseWorkspaceTsdk` — uses the project's `node_modules/typescript`.
- Server-side fuzzy matching for completion; "Move to file" code action enabled.
- Buffer keymaps: organize imports, add missing imports, remove unused, fix all, go to source
  definition (`gS`), select TS version — see [keymaps.md](keymaps.md#code--leaderc).

`after/lsp/eslint.lua`:
- `format = false` — formatting is Prettier's job, ESLint only reports/fixes lint issues.
- Keeps nvim-lspconfig's own `on_attach` (which defines `:LspEslintFixAll`) and adds `<leader>ce`.

## lsp.lua

1. **Install** — `mason.setup()`; `mason-lspconfig` with `automatic_enable = false` (servers are enabled
   explicitly); `mason-tool-installer` ensures every `servers` + `tools` entry is installed on start
   (no auto-update).
2. **Shared config** — `vim.lsp.config('*', { capabilities = blink capabilities })`.
3. **Enable** — `vim.lsp.enable(langs.servers)`. Final config per server =
   nvim-lspconfig `lsp/<name>.lua` ⊕ `vim.lsp.config('*')` ⊕ `after/lsp/<name>.lua`.
4. **Diagnostics UI**
   - Sorted by severity; not updated while typing in insert mode.
   - Virtual text with severity icon prefix; source shown only when several sources exist.
   - Float with icon prefix and coloured severity.
   - Sign column uses the shared icons.
   - Undercurl styling comes from `colorscheme.lua`.
5. **Defaults off** — inlay hints (`<leader>th`) and codelens (`<leader>cl`).
6. **`LspAttach`** — buffer-local keymaps (navigation via Snacks pickers, code actions, rename,
   diagnostics) and, if the server supports `documentHighlight`, highlights other occurrences of the
   symbol under the cursor on `CursorHold` and clears them on move.

## format.lua (conform.nvim)

- `formatters_by_ft` comes from the language registry.
- Filetypes without a configured formatter fall back to the LSP formatter (`lsp_format = 'fallback'`).
- **No format-on-save.** Format manually with `<leader>cf` or `Shift+Alt+F` (async, works on a visual
  selection too).
- `formatexpr` is set to conform, so `gq` also uses it.

## lint.lua (nvim-lint)

- `linters_by_ft` comes from the language registry (currently empty — JS/TS linting is done by the
  ESLint language server).
- Runs on `BufReadPost`, `BufWritePost` and `InsertLeave`.

## Adding a language

Example: Python.

1. Create `lua/langs/python.lua`:

   ```lua
   return {
     servers = { 'basedpyright', 'ruff' },
     formatters = { python = { 'ruff_format', 'ruff_organize_imports' } },
     tools = {},
     parsers = { 'python' },
   }
   ```

2. *(Optional)* Add server settings in `after/lsp/basedpyright.lua` returning a partial
   `vim.lsp.Config` table.
3. Restart Neovim. Mason installs the servers/tools, treesitter compiles the parser, and the
   formatter is registered.

Notes:
- Server names must match nvim-lspconfig's `lsp/<name>.lua` file names; Mason maps them to packages
  through mason-lspconfig.
- `tools` takes **Mason package names** (e.g. `prettierd`, `stylua`, `shellcheck`), for formatters and
  linters that aren't language servers.
- Only use `linters` for tools that aren't already provided as a language server.

## Troubleshooting

| Command | Use |
| --- | --- |
| `:checkhealth vim.lsp` | Which servers are enabled/attached and their config |
| `:lsp restart` / `<leader>cr` | Restart servers for the buffer |
| `:Mason` | Installed packages, install logs |
| `:ConformInfo` | Formatters available for the current buffer, and the log |
| `:checkhealth nvim-treesitter` | Parser status, tree-sitter CLI / compiler detection |
| `:lua =require('langs')` | Inspect the merged language registry |
