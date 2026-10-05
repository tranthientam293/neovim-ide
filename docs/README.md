# Neovim Config — Documentation

A VSCode-flavoured Neovim setup focused on **JavaScript / TypeScript** and **Lua**, built on Neovim's
native plugin manager (`vim.pack`) and native LSP client (`vim.lsp.config` / `vim.lsp.enable`).

## Purpose

- **Feel familiar to VSCode users** — `Ctrl+P`, `Ctrl+B`, `` Ctrl+` ``, `F2`, `F12`, `Shift+Alt+F`,
  `Alt+Up/Down`, `Ctrl+/`, buffer "tabs", a problems panel, inline git blame.
- **Stay small and native** — no lazy.nvim, no LSP wrapper frameworks; uses the APIs that ship with
  Neovim 0.12+.
- **Make languages pluggable** — each language is one file in `lua/langs/` that declares its LSP
  servers, formatters, linters, Mason tools and treesitter parsers. Everything else picks them up
  automatically.

## Documents

| File | Contents |
| --- | --- |
| [getting-started.md](getting-started.md) | Hands-on tour: first launch, finding keys, files, search, code intelligence, git, troubleshooting, exploring the config |
| [core.md](core.md) | Editor options, autocommands, shared icons |
| [keymaps.md](keymaps.md) | Every keybinding, grouped by area |
| [plugins.md](plugins.md) | Each plugin: what it does and how it is configured |
| [lsp-and-languages.md](lsp-and-languages.md) | Language registry, LSP, formatting, linting, treesitter, adding a language |

## Requirements

| Requirement | Why |
| --- | --- |
| Neovim **0.12+** | `vim.pack`, `vim.lsp.config/enable`, `winborder`, `:lsp restart`, `vim.lsp.codelens.enable` |
| A **Nerd Font** in the terminal | Icons in diagnostics, statusline, bufferline, explorer |
| `git` | `vim.pack` clones plugins; gitsigns |
| `tree-sitter` CLI + a C compiler | `nvim-treesitter` (main branch) compiles parsers locally |
| Node.js | `vtsls`, `eslint`, `prettierd` (installed by Mason) |
| `ripgrep` (`rg`) | Snacks grep picker |
| A truecolor terminal (e.g. Windows Terminal) | `termguicolors`, transparent theme, undercurl |

On first launch `vim.pack` installs the plugins, Mason installs the language servers/tools, and
treesitter compiles the parsers (all asynchronously — give it a minute).

## Directory layout

```
nvim/
├── init.lua                 Entry point: core modules, then plugins
├── nvim-pack-lock.json      Plugin versions pinned by vim.pack (commit this)
├── .stylua.toml             Lua formatting rules for this config
├── lua/
│   ├── core/
│   │   ├── options.lua      Editor options (vim.o / vim.opt)
│   │   ├── keymaps.lua      Leader key + plugin-independent keymaps
│   │   ├── autocmds.lua     Generic autocommands
│   │   ├── icons.lua        Shared Nerd Font icons (diagnostics)
│   │   └── lazy.lua         Lazy-loading helpers (on event, after UI, stub command, packadd)
│   ├── langs/
│   │   ├── init.lua         Registry: merges every language spec in this folder
│   │   ├── lua.lua          Lua: lua_ls + stylua
│   │   └── typescript.lua   JS/TS: vtsls + eslint + prettier
│   └── plugins/
│       ├── init.lua         vim.pack.add({...}) + decides when each plugin module loads
│       ├── colorscheme.lua  catppuccin mocha (transparent), undercurl diagnostics
│       ├── ui.lua           Snacks (picker/explorer/terminal/notifications)
│       ├── bufferline.lua   Buffer tabs
│       ├── which-key.lua    Keymap hints
│       ├── statusline.lua   lualine
│       ├── treesitter.lua   Parsers, highlighting, indent, folds, sticky context, autotag
│       ├── editor.lua       ts-comments, gitsigns, trouble
│       ├── completion.lua   blink.cmp, autopairs
│       ├── lsp.lua          Mason, server enabling, diagnostics UI, LSP keymaps
│       ├── format.lua       conform.nvim (manual formatting)
│       └── lint.lua         nvim-lint (non-LSP linters)
├── after/lsp/
│   ├── lua_ls.lua           Per-server overrides, merged on top of nvim-lspconfig
│   ├── vtsls.lua
│   └── eslint.lua
└── docs/                    This documentation
```

## Load order

Plugins are set up in stages so the first screen only waits for what it shows. The helpers are in
`lua/core/lazy.lua`; see [Plugins → Load order](plugins.md#load-order) for details.

```
init.lua
 ├─ core.autocmds
 ├─ core.options
 ├─ core.keymaps            (sets <leader> = <Space> before any plugin maps keys)
 └─ plugins                 (plugins/init.lua)
     ├─ vim.pack.add(...)    put plugins on the runtimepath (blink.cmp, friendly-snippets,
     │                       nvim-ts-autotag are only registered, :packadd-ed later)
     │
     ├─ 1. startup           plugins.colorscheme, plugins.ui (Snacks)
     ├─ 2. after first frame plugins.statusline, plugins.bufferline, plugins.which-key
     ├─ 3. first file opened plugins.treesitter → lsp → format → lint → editor   (also on :Mason)
     └─ 4. first insert/cmd  plugins.completion (blink.cmp, autopairs)
```

`lua/langs/init.lua` is required by `treesitter.lua`, `lsp.lua`, `format.lua` and `lint.lua`;
Lua's module cache means the folder is scanned only once.

## Managing plugins

- **Add**: append the repo URL to `vim.pack.add({...})` in `lua/plugins/init.lua`, configure it in the
  relevant module, restart.
- **Update**: `:lua vim.pack.update()` — review the diff buffer, then `:write` to apply.
  The new commits are recorded in `nvim-pack-lock.json`.
- **Remove**: delete it from `vim.pack.add`, then `:lua vim.pack.del({ 'name' })`.
- **Mason tools**: `:Mason` to inspect; `:MasonToolsInstall` / `:MasonToolsUpdate`
  (auto-update is off).
