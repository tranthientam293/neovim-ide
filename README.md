# Neovim IDE

A lightweight, VSCode-flavoured Neovim configuration for **JavaScript / TypeScript** and **Lua**,
built only on Neovim's native features: the built-in plugin manager (`vim.pack`) and the built-in
LSP client (`vim.lsp.config` / `vim.lsp.enable`). No lazy.nvim, no distro.

- **Familiar shortcuts**: `Ctrl+P`, `Ctrl+B`, `` Ctrl+` ``, `F2`, `F12`, `Shift+Alt+F`, `Alt+↑/↓`, `Ctrl+/`
- **IDE features**: completion, go to definition/references, code actions, inlay hints, problems panel,
  git hunks and blame, file explorer, fuzzy finder, terminal
- **One file per language**: add a file to `lua/langs/` and its LSP servers, formatters, linters and
  treesitter parsers are installed and wired up automatically

📖 **Full documentation lives in the [Wiki](https://github.com/tranthientam293/neovim-ide/wiki).**

## Documentation

| Topic | Wiki page |
| --- | --- |
| Overview, requirements, layout, load order, managing plugins | [Home](https://github.com/tranthientam293/neovim-ide/wiki) |
| Hands-on tour of the setup (start here) | [Getting Started](https://github.com/tranthientam293/neovim-ide/wiki/getting-started) |
| Editor options, autocommands, icons | [Core](https://github.com/tranthientam293/neovim-ide/wiki/core) |
| Every keybinding | [Keymaps](https://github.com/tranthientam293/neovim-ide/wiki/keymaps) |
| Plugins and how each one is configured | [Plugins](https://github.com/tranthientam293/neovim-ide/wiki/plugins) |
| LSP, formatting, linting, treesitter, adding a language | [LSP & Languages](https://github.com/tranthientam293/neovim-ide/wiki/lsp-and-languages) |

## Quick start

Requires **Neovim 0.12+**. See the
[full requirements](https://github.com/tranthientam293/neovim-ide/wiki#requirements) first
(Nerd Font, git, tree-sitter CLI, C compiler, Node.js, ripgrep).

```bash
# Linux / macOS
git clone https://github.com/tranthientam293/neovim-ide.git ~/.config/nvim

# Windows (PowerShell)
git clone https://github.com/tranthientam293/neovim-ide.git $env:LOCALAPPDATA\nvim
```

Then start `nvim`. Plugins, language servers and parsers install automatically on first launch.
Press `Space` to see available keymaps, then follow the
[Getting Started](https://github.com/tranthientam293/neovim-ide/wiki/getting-started) tour.

## Contributing to the docs

The wiki is generated from the [`docs/`](docs) folder by a
[GitHub Action](.github/workflows/wiki.yml) on every push to `master`. Edit files in `docs/`, not
in the wiki, because the wiki is overwritten on each sync.
