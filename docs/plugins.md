# Plugins

All plugins are declared in `lua/plugins/init.lua` with Neovim's built-in `vim.pack.add`. Exact
commits are pinned in `nvim-pack-lock.json`. Each group is configured in its own module.

## Overview

| Plugin | Purpose | Configured in | Loaded |
| --- | --- | --- | --- |
| catppuccin | Colorscheme (mocha) | `colorscheme.lua` | startup |
| snacks.nvim | Picker, explorer, terminal, indent guides, notifications, input, big-file handling | `ui.lua` | startup |
| nvim-web-devicons | File-type icons | (used by others) | startup |
| lualine.nvim | Statusline | `statusline.lua` | after first frame |
| bufferline.nvim | Buffers shown as tabs | `bufferline.lua` | after first frame |
| which-key.nvim | Keymap hints popup | `which-key.lua` | after first frame |
| noice.nvim, nui.nvim | Floating command line, messages | `noice.lua` | after first frame |
| nvim-treesitter (`main`) | Parsers, highlighting, indent, folds | `treesitter.lua` | first file |
| nvim-treesitter-context | Sticky scroll | `treesitter.lua` | first file |
| nvim-ts-autotag | Auto close/rename HTML/JSX tags | `treesitter.lua` | first file (`:packadd`) |
| ts-comments.nvim | Correct comment strings in JSX/TSX | `editor.lua` | first file |
| gitsigns.nvim | Git signs, hunks, blame | `editor.lua` | first file |
| trouble.nvim | Problems panel, symbols outline | `editor.lua` | first `:Trouble` |
| mason.nvim, mason-lspconfig, mason-tool-installer | Install servers & tools | `lsp.lua` | first file or `:Mason` |
| nvim-lspconfig | Default server configs (`lsp/<name>.lua`) | `lsp.lua` + `after/lsp/` | first file |
| conform.nvim | Formatting | `format.lua` | first file |
| nvim-lint | Non-LSP linters | `lint.lua` | first file |
| blink.cmp (`1.*`) | Completion | `completion.lua` | `:packadd` on first file (LSP capabilities), setup on first insert |
| friendly-snippets | Snippet collection | `completion.lua` | first insert (`:packadd`) |
| nvim-autopairs | Auto-close brackets and quotes | `completion.lua` | first insert |
| render-markdown.nvim | Markdown preview rendered in the buffer | `markdown.lua` | first markdown buffer (`:packadd`) |

## Load order

Everything is installed by `vim.pack.add` in `plugins/init.lua`, but each module is set up only when
it is first needed. That keeps an empty start at roughly 220 ms instead of about 620 ms. The helpers are
in `lua/core/lazy.lua`:

| Helper | What it does |
| --- | --- |
| `lazy.on(events, loader)` | Runs `loader` the first time one of `events` fires |
| `lazy.after_ui(loader)` | Runs `loader` right after the first screen is drawn (`UIEnter` + `vim.schedule`) |
| `lazy.cmd(name, loader)` | Defines a stub `:name` command that runs `loader` and then re-runs the real command |
| `lazy.packadd(name)` | `:packadd`s a plugin that was registered but not loaded (once) |
| `lazy.once(fn)` | Wraps `fn` so it only runs once |

A *loader* is either a module name (`'plugins.statusline'`) or a function.

| Stage | Trigger | Modules |
| --- | --- | --- |
| 1 | startup | `colorscheme`, `ui` (Snacks) |
| 2 | after the first frame | `statusline`, `bufferline`, `which-key`, `noice` |
| 3 | `BufReadPre` / `BufNewFile`, or `:Mason` | `treesitter`, `lsp`, `format`, `lint`, `editor` |
| 4 | `InsertEnter` / `CmdlineEnter` | `completion` |
| 5 | `FileType markdown` | `markdown` |

Notes:
- **No layout jump when stage 2 loads**: `plugins/init.lua` reserves a blank statusline and tabline at
  startup.
- **`nvim file` still works**: `BufReadPre` fires for files given on the command line, so stage 3
  loads before that buffer's `FileType` event and treesitter, LSP and lint all attach to it. Snacks
  `quickfile` shows the file with highlighting as early as possible.
- **Registered but not loaded**: blink.cmp, friendly-snippets, nvim-ts-autotag and render-markdown.nvim are added with
  `{ load = function() end }`, which keeps their `plugin/` files from running at startup. blink.cmp is
  `:packadd`ed by `lsp.lua` because its `plugin/` file adds completion capabilities to every server,
  and that has to happen before any server starts.
- **Late Mason check**: mason-tool-installer normally checks for missing tools on `VimEnter`. When
  `lsp.lua` loads after that, it starts the check itself.
- **Adding a plugin**: put its `setup()` in the module for the stage where it's first needed. If its
  `plugin/` file is slow, register it in the second `vim.pack.add` call and `lazy.packadd()` it before
  `require`.
---

## colorscheme.lua

- **Theme**: fixed to `catppuccin-mocha`, with a **transparent background** (floats too). There is no
  theme switcher; change `colorscheme.lua` to use another theme.
- **Undercurl**: a `ColorScheme` autocmd rewrites every `DiagnosticUnderline*` group to use undercurl
  instead of underline.
- **Catppuccin integrations**: blink.cmp, Mason, and a lualine override that keeps the statusline's
  middle section solid (`mantle`) despite transparency.

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

## bufferline.lua

VSCode-like tab bar of open buffers:
- Close / right-click close through `Snacks.bufdelete`.
- Shows LSP error/warning counts per buffer using the shared icons.
- Offsets itself next to the Snacks explorer with an "Explorer" title.
- Always visible, even with one buffer.

## which-key.lua

`modern` preset. Named groups: `b` buffer, `c` code, `d` diagnostics, `f` find, `g` git,
`s` split/session, `t` tab/toggle, `m` markdown.

## noice.lua

- **Command line**: `:` opens a floating popup in the center of the screen (Noice's default
  `cmdline_popup` position) instead of the built-in bottom line, with completions below it. `/` and
  `?` stay at the bottom (`bottom_search`).
- **Messages**: `:echo`/errors show as notifications through Snacks notifier; long ones open in a split
  (`long_message_to_split`). `<leader>fm` searches the message history.
- **LSP**: Noice renders hover docs; its signature help is off because blink.cmp already shows it.
- Loaded right after the first frame, so messages printed during startup still use the built-in UI.

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

- **ts-comments.nvim** — makes the built-in `gc` / `Ctrl+/` use the right comment syntax inside JSX.
- **gitsigns.nvim** — signs in the gutter; inline blame is off by default (`<leader>tb`). Buffer-local
  hunk keymaps are defined in `on_attach` (see [keymaps.md](keymaps.md#git--leaderg-gitsigns-git-buffers-only)).
- **trouble.nvim** — problems panel (`<leader>dp`, `<leader>db`) and symbols outline (`<leader>ds`).
  Set up the first time `:Trouble` runs (a stub command created with `lazy.cmd`).

## completion.lua (blink.cmp, autopairs)

- **nvim-autopairs** with `check_ts = true` (treesitter-aware, e.g. no pairing inside strings).
- **blink.cmp**:

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

blink's `plugin/` file adds its completion capabilities to every server (`vim.lsp.config('*')`), so
`lsp.lua` `:packadd`s blink.cmp before enabling servers.

## markdown.lua

- **render-markdown.nvim** uses extmarks and conceal to draw headings, code blocks, tables, lists,
  checkboxes and links in the same buffer. The file on disk is never changed.
- Rendering is on in normal mode, including the cursor line (`anti_conceal` is off). Insert mode
  shows raw text.
- `<leader>mp` toggles between preview and raw for every markdown buffer. `<leader>ms` opens a
  rendered copy in a side split next to the raw buffer.
- The plugin's `plugin/` file calls `setup(vim.g.render_markdown_config)` and then attaches to the
  current buffer, so `markdown.lua` sets that variable before it `:packadd`s the plugin. The parsers
  it needs (`markdown`, `markdown_inline`) come from `lua/langs/markdown.lua`.

## lsp.lua, format.lua, lint.lua

See [lsp-and-languages.md](lsp-and-languages.md).
