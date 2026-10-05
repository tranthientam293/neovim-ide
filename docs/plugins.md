# Plugins

All plugins are declared in `lua/plugins/init.lua` with Neovim's built-in `vim.pack.add`. Exact
commits are pinned in `nvim-pack-lock.json`. Each group is configured in its own module.

## Overview

| Plugin | Purpose | Configured in |
| --- | --- | --- |
| catppuccin, tokyonight, kanagawa, gruvbox, solarized-osaka | Colorschemes | `colorscheme.lua` |
| snacks.nvim | Picker, explorer, terminal, indent guides, notifications, input, big-file handling | `ui.lua` |
| bufferline.nvim | Buffers shown as tabs | `ui.lua` |
| which-key.nvim | Keymap hints popup | `ui.lua` |
| nvim-web-devicons | File-type icons | (used by others) |
| lualine.nvim | Statusline | `statusline.lua` |
| nvim-treesitter (`main`) | Parsers, highlighting, indent, folds | `treesitter.lua` |
| nvim-treesitter-context | Sticky scroll | `treesitter.lua` |
| nvim-ts-autotag | Auto close/rename HTML/JSX tags | `treesitter.lua` |
| nvim-autopairs | Auto-close brackets and quotes | `editor.lua` |
| ts-comments.nvim | Correct comment strings in JSX/TSX | `editor.lua` |
| gitsigns.nvim | Git signs, hunks, blame | `editor.lua` |
| trouble.nvim | Problems panel, symbols outline | `editor.lua` |
| mason.nvim, mason-lspconfig, mason-tool-installer | Install servers & tools | `lsp.lua` |
| nvim-lspconfig | Default server configs (`lsp/<name>.lua`) | `lsp.lua` + `after/lsp/` |
| blink.cmp (`1.*`) + friendly-snippets | Completion & snippets | `completion.lua` |
| conform.nvim | Formatting | `format.lua` |
| nvim-lint | Non-LSP linters | `lint.lua` |

---

## colorscheme.lua

- **Default theme**: `catppuccin-mocha`, with a **transparent background** (floats too).
- **Switch**: `<leader>tc` opens a Snacks picker with live preview. The choice is written to
  `stdpath('state')/colorscheme` and restored on next start. If the saved theme fails to load, the
  default is used.
- **Undercurl**: a `ColorScheme` autocmd rewrites every `DiagnosticUnderline*` group to use undercurl
  instead of underline, so it applies to any theme.
- **Catppuccin integrations**: blink.cmp, Mason, and a lualine override that keeps the statusline's
  middle section solid (`mantle`) despite transparency.
- Other themes: tokyonight (`night`), kanagawa, gruvbox, solarized-osaka (transparent).

## ui.lua

### snacks.nvim

| Module | Settings / purpose |
| --- | --- |
| `bigfile` | Disables heavy features on very large files |
| `quickfile` | Renders the file before plugins finish loading when opening `nvim file` |
| `indent` | Indent guides + current scope, thin `▏` character |
| `input` | Nicer `vim.ui.input` (e.g. rename prompt) |
| `notifier` | Toast notifications; icons padded with an extra space so Nerd Font glyphs aren't clipped in Windows Terminal |
| `explorer` | File tree sidebar, replaces netrw; shows hidden **and** gitignored files (dimmed) |
| `terminal` | Floating/split terminal toggle |
| `picker` | Fuzzy finder; `files` and `grep` include dotfiles but respect `.gitignore` |

`Snacks.bufdelete` is also used everywhere a buffer is closed so the window layout is kept.

### bufferline.nvim

VSCode-like tab bar of open buffers:
- Close / right-click close through `Snacks.bufdelete`.
- Shows LSP error/warning counts per buffer using the shared icons.
- Offsets itself next to the Snacks explorer with an "Explorer" title.
- Always visible, even with one buffer.

### which-key.nvim

`modern` preset. Named groups: `b` buffer, `c` code, `d` diagnostics, `f` find, `g` git,
`s` split/session, `t` tab/toggle.

## statusline.lua (lualine)

- `theme = 'auto'` → follows the colorscheme.
- `globalstatus = true` → one statusline for all windows.
- Powerline separators.

| Section | Content |
| --- | --- |
| a | Mode |
| b | Git branch, diff stats |
| c | Relative file path, diagnostics counts |
| x | LSP client status, filetype |
| y | Progress (%) |
| z | Line:column |

Also sets `showmode = false` since the mode is in the statusline.

## treesitter.lua

- **Parsers**: base set `vim, vimdoc, query, regex, diff, bash` + every `parsers` entry from
  `lua/langs/*.lua`. Installed asynchronously; already-installed parsers are skipped.
- **Per filetype** (`FileType` autocmd): if a parser exists, start treesitter highlighting and set
  treesitter-based `indentexpr` and `foldexpr`. Otherwise nothing changes (Vim regex syntax is used).
- **treesitter-context**: sticky header showing the enclosing function/class, max 3 lines.
- **nvim-ts-autotag**: auto close and rename paired tags in HTML/JSX/TSX.

> The `main` branch of nvim-treesitter is a rewrite: there is no `ensure_installed` or
> `highlight = { enable = true }`; highlighting is started manually as above.

## editor.lua

- **nvim-autopairs** with `check_ts = true` (treesitter-aware, e.g. no pairing inside strings).
- **ts-comments.nvim** — makes the built-in `gc` / `Ctrl+/` use the right comment syntax inside JSX.
- **gitsigns.nvim** — signs in the gutter; inline blame is off by default (`<leader>tb`). Buffer-local
  hunk keymaps are defined in `on_attach` (see [keymaps.md](keymaps.md#git--leaderg-gitsigns-git-buffers-only)).
- **trouble.nvim** — problems panel (`<leader>dp`, `<leader>db`) and symbols outline (`<leader>ds`).

## completion.lua (blink.cmp)

| Setting | Value | Purpose |
| --- | --- | --- |
| `keymap.preset` | `enter` | `Enter` accepts |
| `Tab` / `S-Tab` | select & accept / snippet jump | VSCode-like |
| `list.selection` | `preselect = true, auto_insert = false` | First item highlighted, text not inserted until accepted |
| `accept.auto_brackets` | enabled | Adds `()` after functions |
| `documentation` | auto show after 200 ms | Docs panel next to the menu |
| `signature` | enabled | Parameter hints while typing a call |
| `sources` | `lsp, path, snippets, buffer` | Snippets come from friendly-snippets |
| `fuzzy` | `prefer_rust_with_warning` | Uses the prebuilt Rust matcher (needs the `1.*` version tag) |

blink's LSP capabilities are passed to every server in `lsp.lua`.

## lsp.lua, format.lua, lint.lua

See [lsp-and-languages.md](lsp-and-languages.md).
