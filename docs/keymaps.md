# Keymaps

`<leader>` is **Space**. Press `<leader>` and wait to see the which-key popup; `<leader>fk` searches
every keymap.

Columns: **Mode** — `n` normal, `i` insert, `v` visual+select, `x` visual, `t` terminal.
**Source** — the file that defines it.

## VSCode-style shortcuts

| Keys | Mode | Action | Source |
| --- | --- | --- | --- |
| `Ctrl+s` | n, i, x | Save file | core/keymaps |
| `Ctrl+q` | n | Quit window | core/keymaps |
| `Ctrl+p` | n | Find files | plugins/ui |
| `Ctrl+b` | n | Toggle file explorer | plugins/ui |
| `` Ctrl+` `` | n, t | Toggle terminal | plugins/ui |
| `Ctrl+/` | n, x, i | Toggle comment | core/keymaps |
| `Alt+Up` / `Alt+k` | n, i, v | Move line(s) up | core/keymaps |
| `Alt+Down` / `Alt+j` | n, i, v | Move line(s) down | core/keymaps |
| `Shift+Alt+Down` | n, v | Duplicate line/selection down | core/keymaps |
| `Shift+Alt+f` | n, v | Format buffer/selection | plugins/format |
| `F2` | n | Rename symbol | plugins/lsp |
| `F12` | n | Go to definition | plugins/lsp |
| `Shift+F12` | n | Find references | plugins/lsp |
| `Ctrl+.` | n, v | Code action | plugins/lsp |
| `Ctrl+Shift+o` | n | Document symbols | plugins/lsp |
| `Alt+1` … `Alt+9` | n | Go to buffer tab N | plugins/bufferline |
| `Tab` / `Shift+Tab` | n | Next / previous buffer tab | plugins/bufferline |

> Note: `Ctrl+s` in insert mode saves the file, which overrides Neovim's built-in insert-mode
> signature help. Signature help still appears automatically via blink.cmp while typing.

## Movement & editing

| Keys | Mode | Action |
| --- | --- | --- |
| `j` / `k` | n | Move by display line when no count is given (works with wrapped lines) |
| `Ctrl+d` / `Ctrl+u` | n | Half-page scroll, keep cursor centred |
| `n` / `N` | n | Next/previous match, centred and unfolded |
| `Ctrl+h/j/k/l` | n, t | Move to left/down/up/right window (also out of the terminal) |
| `Ctrl+Up/Down` | n | Increase/decrease window height |
| `Ctrl+Left/Right` | n | Increase/decrease window width |
| `<Esc>` | n | Clear search highlight |
| `jk` / `kj` | i | Exit insert mode |
| `<` / `>` | v | Indent and keep the selection |
| `x` | n | Delete character without overwriting the register |
| `p` | v | Paste over selection without losing the yanked text |
| `<leader>j` | n | Replace word under cursor (then `.` to repeat on next match) |
| `<leader>y` | n, v | Yank to system clipboard |
| `<leader>Y` | n | Yank line to system clipboard |
| `<leader>+` / `<leader>-` | n | Increment / decrement number |
| `<leader>lw` | n | Toggle line wrap |
| `<leader>sn` | n | Save without autocommands (no formatters/linters) |

## Find — `<leader>f` (Snacks picker)

| Keys | Action |
| --- | --- |
| `<leader><space>` | Smart find (buffers + recent + files) |
| `<leader>ff` | Find files (includes dotfiles, respects `.gitignore`) |
| `<leader>fg` | Live grep in project |
| `<leader>fw` | Grep word under cursor / selection (n, x) |
| `<leader>fb` | Open buffers |
| `<leader>fr` | Recent files |
| `<leader>fc` | Command palette |
| `<leader>fk` | Keymaps |
| `<leader>fh` | Help pages |
| `<leader>f/` | Search lines in current buffer |
| `<leader>fR` | Resume last picker |
| `<leader>fn` | Notification history |
| `<leader>fm` | Message history (Noice) |
| `<leader>fs` | Document symbols (LSP) |
| `<leader>fS` | Workspace symbols (LSP) |
| `<leader>e` | Toggle file explorer |

## Buffers — `<leader>b`

| Keys | Action |
| --- | --- |
| `<leader>x` | Close buffer (keeps window layout) |
| `<leader>bo` | Close all other buffers |
| `<leader>bp` | Pick a buffer by letter |
| `<leader>bP` | Pin / unpin buffer |

## Splits & sessions — `<leader>s`

| Keys | Action |
| --- | --- |
| `<leader>sv` | Split vertically |
| `<leader>sh` | Split horizontally |
| `<leader>se` | Equalise split sizes |
| `<leader>sx` | Close current split |
| `<leader>ss` | Save session to `./.session.vim` |
| `<leader>sl` | Load session from `./.session.vim` |
| `<leader>sn` | Save without autocommands |

## Tabs & toggles — `<leader>t`

| Keys | Action |
| --- | --- |
| `<leader>to` | New tab page |
| `<leader>tx` | Close tab page |
| `<leader>tn` / `<leader>tp` | Next / previous tab page |
| `<leader>tt` | Toggle terminal |
| `<leader>th` | Toggle inlay hints (LSP buffers) |
| `<leader>tb` | Toggle inline git blame (git buffers) |

## Code — `<leader>c`

| Keys | Action | Available in |
| --- | --- | --- |
| `<leader>ca` | Code action (n, v) | any LSP buffer |
| `<leader>rn` | Rename symbol | any LSP buffer |
| `<leader>cf` | Format buffer/selection (n, v) | everywhere |
| `<leader>cl` | Toggle codelens | any LSP buffer |
| `<leader>cr` | Restart LSP | any LSP buffer |
| `<leader>co` | Organize imports | TS/JS (vtsls) |
| `<leader>cM` | Add missing imports | TS/JS (vtsls) |
| `<leader>cu` | Remove unused imports/code | TS/JS (vtsls) |
| `<leader>cF` | Fix all (TypeScript) | TS/JS (vtsls) |
| `<leader>cV` | Select TypeScript version | TS/JS (vtsls) |
| `<leader>ce` | ESLint: fix all | eslint buffers |

## LSP navigation

Active once a language server attaches. Results open in a Snacks picker with preview.

| Keys | Action |
| --- | --- |
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gy` | Go to type definition |
| `gS` | Go to source definition (TS: skips `.d.ts`) |
| `grr` | Find references |
| `gri` | Go to implementation |
| `K` | Hover documentation *(Neovim default)* |
| `grn` | Rename *(Neovim default)* |
| `gra` | Code action *(Neovim default)* |
| `grt` | Type definition *(Neovim default)* |
| `gO` | Document symbols *(Neovim default)* |

## Diagnostics — `<leader>d`

| Keys | Action |
| --- | --- |
| `[d` / `]d` | Previous / next diagnostic *(Neovim default)* |
| `<leader>dl` | Show diagnostics for the current line (float) |
| `<leader>dd` | Buffer diagnostics (picker) |
| `<leader>dD` | Workspace diagnostics (picker) |
| `<leader>dp` | Problems panel — workspace (Trouble) |
| `<leader>db` | Problems panel — current buffer (Trouble) |
| `<leader>ds` | Symbols outline (Trouble) |
| `<leader>dt` | Toggle diagnostics on/off |
| `<leader>q` | Send diagnostics to the location list |

## Git — `<leader>g` (gitsigns, git buffers only)

| Keys | Action |
| --- | --- |
| `]h` / `[h` | Next / previous hunk |
| `<leader>gp` | Preview hunk |
| `<leader>gs` | Stage hunk (n, v) |
| `<leader>gr` | Reset hunk (n, v) |
| `<leader>gb` | Blame current line |
| `<leader>gd` | Diff against index |
| `<leader>tb` | Toggle inline blame |

## Markdown — `<leader>m` (markdown buffers only)

| Keys | Action |
| --- | --- |
| `<leader>mp` | Toggle preview / raw |
| `<leader>ms` | Preview in a side split |

## Completion (insert mode, blink.cmp)

| Keys | Action |
| --- | --- |
| `Ctrl+Space` | Open menu / docs |
| `Enter` | Accept selected item |
| `Tab` | Accept item, or jump to next snippet placeholder |
| `Shift+Tab` | Jump to previous snippet placeholder |
| `Up` / `Down`, `Ctrl+p` / `Ctrl+n` | Move in menu |
| `Ctrl+e` | Close menu |

## Folding (treesitter)

Standard Vim fold keys work on syntax-aware folds: `za` toggle, `zc` close, `zo` open, `zM` close all,
`zR` open all.
