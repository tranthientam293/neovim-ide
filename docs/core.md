# Core

`lua/core/` holds everything that does not depend on a plugin. It loads before plugins so the leader
key and options are in place when plugins initialise.

## options.lua

### Search

| Option | Value | Purpose |
| --- | --- | --- |
| `hlsearch` | `true` | Highlight all matches (clear with `<Esc>`) |
| `incsearch` | `true` | Show matches while typing the pattern |
| `ignorecase` + `smartcase` | `true` | Case-insensitive unless the pattern contains a capital |

### Display

| Option | Value | Purpose |
| --- | --- | --- |
| `number` + `relativenumber` | `true` | Absolute number on the cursor line, relative elsewhere (for `5j`, `3k`) |
| `numberwidth` | `4` | Gutter width for line numbers |
| `signcolumn` | `yes` | Always reserve the sign column so text doesn't shift when diagnostics/git signs appear |
| `cursorline` | `true` | Highlight the current line |
| `termguicolors` | `true` | 24-bit colour (required by the theme) |
| `wrap` | `false` | No soft wrap by default (toggle with `<leader>lw`) |
| `linebreak` | `true` | When wrap is on, break at word boundaries |
| `breakindent` | `true` | Wrapped lines keep their indentation |
| `scrolloff` / `sidescrolloff` | `4` / `8` | Keep context lines/columns around the cursor |
| `conceallevel` | `0` | Never hide characters (e.g. quotes in JSON, markup in Markdown) |
| `cmdheight` | `1` | One-line command area |
| `pumheight` | `10` | Max items in popup menus |
| `showmode` | `true` → later `false` | Set again to `false` in `statusline.lua` because lualine shows the mode |
| `winborder` | `rounded` | Rounded borders on hover, signature help and diagnostic floats |
| `guicursor` | see file | Block in normal/visual, bar in insert, underline in replace/operator-pending, blinking |

### Editing & indentation

| Option | Value | Purpose |
| --- | --- | --- |
| `shiftwidth` / `tabstop` / `softtabstop` | `2` | 2-space indentation |
| `expandtab` | `true` | Insert spaces instead of tabs |
| `autoindent` + `smartindent` | `true` | Basic auto-indent (treesitter `indentexpr` takes over where a parser exists) |
| `backspace` | `indent,eol,start` | Backspace over everything in insert mode |
| `whichwrap` | `bs<>[]hl` | `h`/`l`/arrows/backspace move across line boundaries |
| `iskeyword` | `+-` | `kebab-case-words` count as one word (`w`, `*`, `ciw`) |
| `formatoptions` | `-c -r -o` | Don't auto-continue comments on new lines |
| `completeopt` | `menuone,noselect` | Native completion behaviour (blink.cmp handles real completion) |
| `mouse` | `a` | Mouse in all modes |
| `clipboard` | `unnamedplus` | Yank/paste use the system clipboard |

### Files

| Option | Value | Purpose |
| --- | --- | --- |
| `undofile` | `true` | Persistent undo across sessions |
| `swapfile` / `backup` / `writebackup` | `false` | No `.swp` / backup files |
| `fileencoding` | `utf-8` | Write files as UTF-8 |

### Misc

| Option | Value | Purpose |
| --- | --- | --- |
| `updatetime` | `250` | Faster `CursorHold` → quicker LSP reference highlighting |
| `foldlevel` / `foldlevelstart` | `99` | Folds exist (treesitter) but everything starts open |
| `shortmess` | `+c` | Hide "match x of y" completion messages |
| `runtimepath` | `-usr/share/vim/vimfiles` | Don't load the system Vim runtime (Unix-only path) |

## autocmds.lua

| Event | Purpose |
| --- | --- |
| `TextYankPost` | Briefly highlight yanked text (200 ms) |

Other autocommands live with the feature they belong to:

| Where | Event | Purpose |
| --- | --- | --- |
| `plugins/colorscheme.lua` | `ColorScheme` | Turn diagnostic underlines into undercurls |
| `plugins/treesitter.lua` | `FileType` | Start treesitter highlighting, indent and folding |
| `plugins/lsp.lua` | `LspAttach` | Buffer-local LSP keymaps and reference highlighting |
| `plugins/lint.lua` | `BufReadPost`, `BufWritePost`, `InsertLeave` | Run nvim-lint |

## icons.lua

Shared Nerd Font glyphs for diagnostic severities (`ERROR`, `WARN`, `INFO`, `HINT`). Used by:

- the sign column and virtual text (`plugins/lsp.lua`)
- the lualine diagnostics component (`plugins/statusline.lua`)
- the bufferline diagnostics indicator (`plugins/bufferline.lua`)

Change an icon here and it updates everywhere.

## keymaps.lua

Sets `<leader>` and `<localleader>` to `<Space>` and defines the plugin-independent mappings.
See [keymaps.md](keymaps.md) for the full list.

## lazy.lua

Small helpers that `plugins/init.lua` and the plugin modules use to set up plugins only when they
are first needed: `on` (first time an event fires), `after_ui` (after the first frame), `cmd` (stub
command), `packadd` and `once`. See [Plugins → Load order](plugins.md#load-order).
