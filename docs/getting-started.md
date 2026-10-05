# Getting Started

A hands-on tour of this setup. Follow it top to bottom the first time, which takes about 15 minutes.
It covers the editor first and then shows where each part of the config lives so you can change it.

`<leader>` means **Space**. `Ctrl+x` style keys are written as they'd be in VSCode.

---

## 1. First launch

```bash
nvim
```

On the very first start, three things install in the background:

| What | Where to watch it | Done when |
| --- | --- | --- |
| Plugins (`vim.pack`) | Messages at the bottom | Neovim opens with the catppuccin theme |
| Language servers & formatters (Mason) | `:Mason` | `vtsls`, `eslint`, `lua_ls`, `prettierd`, `stylua` show as installed |
| Treesitter parsers | Notifications, top right | No more "installing" messages |

Mason and treesitter only start once you open a file, or `:Mason` for Mason. Open any file, give
them a minute, then restart Neovim.

**Check everything is healthy:**

```vim
:checkhealth vim.lsp
:checkhealth nvim-treesitter
:checkhealth blink.cmp
```

If an icon shows as a box or `?`, your terminal isn't using a Nerd Font. See
[Requirements](README.md#requirements).

---

## 2. Know the screen

```
┌──────────────────────────────────────────────────────────────┐
│  init.lua   keymaps.lua   ● lsp.lua            ← buffer tabs│
├──────────────┬───────────────────────────────────────────────┤
│ Explorer     │  1  local M = {}                              │
│  lua/        │  2  ▏ function M.setup()  ← indent guides     │
│   core/      │  3  ▏ ▏ ...                                   │
│   plugins/   │                     ● undefined global  ← diag│
├──────────────┴───────────────────────────────────────────────┤
│ NORMAL │  master +2 ~1 │ lua/plugins/lsp.lua  1  │ lua_ls ✓ │
└──────────────────────────────────────────────────────────────┘
   mode     git branch/diff   file + diagnostics    LSP status
```

- **Top, buffer tabs**: every open file. `Tab`/`Shift+Tab` to cycle, `Alt+1…9` to jump,
  `<leader>x` to close.
- **Left, explorer**: toggle with `Ctrl+b` or `<leader>e`.
- **Bottom, statusline**: mode, git branch and changes, file path, error/warning counts, attached
  language servers, position.
- **Line numbers**: the current line shows its real number; the others show their distance from it,
  so `5j` / `3k` are easy to count.
- **Sign column** (left of numbers): git changes and diagnostic icons.

---

## 3. Discover keys without memorising them

You only need to remember three things:

| Key | What you get |
| --- | --- |
| `Space` (then wait) | **which-key** popup listing every `<leader>` key, grouped: `b` buffer, `c` code, `d` diagnostics, `f` find, `g` git, `s` split/session, `t` tab/toggle |
| `<leader>fk` | Searchable list of **every** keymap, with descriptions |
| `<leader>fc` | **Command palette**: search all `:commands` |

Try it now: press `Space`, then `f`, and read what the popup offers.

Full reference: [Keymaps](keymaps.md).

---

## 4. Open files

| Try this | Key |
| --- | --- |
| Fuzzy-find a file by name | `Ctrl+p` or `<leader>ff` |
| Smart find (open buffers, then recent, then all files) | `<leader><space>` |
| Recently opened files | `<leader>fr` |
| Toggle the file tree | `Ctrl+b` |

**Inside any picker** (file finder, grep, explorer):
- Type to filter. Fuzzy matching works, so `plulsp` finds `plugins/lsp.lua`.
- `Up`/`Down` or `Ctrl+n`/`Ctrl+p` to move, `Enter` to open.
- `Esc` switches to normal mode in the list. Press `?` there to see every picker key,
  including open in split, toggle hidden or ignored files, and send results to the quickfix list.
- `Esc` again closes it.

**Explorer**: it's a picker too. Use `Enter` to open, `?` to see its keys (create, rename,
delete, copy, move). Dotfiles and git-ignored files are shown; ignored ones are dimmed.

---

## 5. Search the project

| Try this | Key |
| --- | --- |
| Search text in all files (live grep) | `<leader>fg` |
| Search the word under the cursor, or the selection | `<leader>fw` |
| Search lines in the current file | `<leader>f/` |
| Reopen the last search exactly as you left it | `<leader>fR` |
| Search help pages | `<leader>fh` |

Inside the current file, the usual `/pattern` works. `n`/`N` jump between matches and keep the
match centred, and `Esc` clears the highlight.

---

## 6. Edit like in VSCode

| Action | Key |
| --- | --- |
| Save | `Ctrl+s` (any mode) |
| Comment / uncomment | `Ctrl+/` (line or selection) |
| Move line(s) up / down | `Alt+Up` / `Alt+Down` |
| Duplicate line down | `Shift+Alt+Down` |
| Format file or selection | `Shift+Alt+f` or `<leader>cf` |
| Leave insert mode | `Esc`, or type `jk` quickly |
| Undo / redo | `u` / `Ctrl+r` (undo history survives restarts) |

Things that happen automatically:
- Brackets and quotes close themselves.
- Typing `<div>` adds `</div>`, and renaming the opening tag renames the closing one (HTML/JSX/TSX).
- The current function's header sticks to the top when you scroll past it.
- Yanking (`y`) briefly highlights what was copied, and it goes to the system clipboard.

**Formatting is never automatic.** Saving doesn't reformat; press `Shift+Alt+f` when you want it.

---

## 7. Code intelligence tour

Open a TypeScript or Lua file (e.g. `lua/plugins/lsp.lua`) and wait until the statusline shows the
server (`lua_ls`, `vtsls`). Then try each of these on a function or variable name:

| Step | Key | What happens |
| --- | --- | --- |
| 1 | `K` | Hover: type and documentation |
| 2 | `gd` / `F12` | Go to definition (picker with preview if several) |
| 3 | `Ctrl+o` | Jump back (`Ctrl+i` forward again) |
| 4 | `grr` / `Shift+F12` | All references |
| 5 | `F2` / `<leader>rn` | Rename everywhere |
| 6 | `<leader>ca` / `Ctrl+.` | Code actions / quick fixes |
| 7 | `<leader>fs` | Jump to a symbol in this file |
| 8 | `<leader>th` | Toggle inlay hints (parameter names, types) |

**Completion**: start typing in insert mode. `Enter` or `Tab` accepts, `Ctrl+Space` opens the menu
manually, and docs appear beside the menu. Snippets show up in the list too; after accepting one,
`Tab` / `Shift+Tab` move between its placeholders. While typing a function call, a parameter-hint
popup shows the signature.

**TypeScript extras**: `<leader>co` organize imports, `<leader>cM` add missing imports,
`<leader>cu` remove unused, `gS` go to the real source (not the `.d.ts`), `<leader>ce` ESLint fix all.

---

## 8. Find and fix problems

Errors and warnings appear as icons in the sign column, short messages at the end of the line,
and wavy underlines.

| Action | Key |
| --- | --- |
| Next / previous problem | `]d` / `[d` |
| Full message for this line | `<leader>dl` |
| Problems panel, whole project (VSCode `Ctrl+Shift+M`) | `<leader>dp` |
| Problems panel, this file | `<leader>db` |
| Symbols outline | `<leader>ds` |
| Hide / show all diagnostics | `<leader>dt` |

---

## 9. Git

In any file inside a git repo:

| Action | Key |
| --- | --- |
| Next / previous change (hunk) | `]h` / `[h` |
| Preview what changed | `<leader>gp` |
| Stage / reset this hunk | `<leader>gs` / `<leader>gr` |
| Who wrote this line | `<leader>gb` |
| Inline blame on every line (GitLens-like) | `<leader>tb` |
| Diff against the staged version | `<leader>gd` |

The statusline shows the branch and the counts of added, changed and removed lines.

---

## 10. Windows, buffers and the terminal

| Action | Key |
| --- | --- |
| Split vertically / horizontally | `<leader>sv` / `<leader>sh` |
| Move between splits | `Ctrl+h/j/k/l` |
| Resize | `Ctrl+Arrow keys` |
| Close split | `<leader>sx` |
| Toggle terminal | `` Ctrl+` `` or `<leader>tt` |
| Leave the terminal to another split | `Ctrl+h/j/k/l` |
| Close other buffers | `<leader>bo` |
| Save / restore the window layout for this folder | `<leader>ss` / `<leader>sl` |

---

## 11. When something seems off

| Symptom | Look here |
| --- | --- |
| A notification flashed by | `<leader>fn` (notification history) or `:messages` |
| No completion / go-to-definition | Statusline LSP section; `:checkhealth vim.lsp`; `<leader>cr` restarts the server |
| A server or formatter is missing | `:Mason` (`i` to install on a line, `g?` for help) |
| Formatting does nothing | `:ConformInfo` lists the formatters for this file and their log |
| No syntax colours for a language | `:checkhealth nvim-treesitter`, and check the parser is listed in `lua/langs/*.lua` |
| Startup feels slow | `nvim --startuptime startup.log`, then open `startup.log` |

---

## 12. Explore the config itself

Open the config folder from anywhere:

```vim
:e $MYVIMRC          " opens init.lua; Ctrl+b to see the tree
```

or `<leader>ff` while in that folder.

**Where to change what:**

| I want to… | Edit |
| --- | --- |
| Change an editor option (tabs, numbers, wrap…) | `lua/core/options.lua` · [Core](core.md) |
| Add or change a keymap that doesn't need a plugin | `lua/core/keymaps.lua` · [Keymaps](keymaps.md) |
| Change how the picker, explorer or terminal behave | `lua/plugins/ui.lua` |
| Change the statusline / tabs / which-key | `lua/plugins/statusline.lua`, `bufferline.lua`, `which-key.lua` |
| Change the theme | `lua/plugins/colorscheme.lua` |
| Change completion behaviour | `lua/plugins/completion.lua` |
| Change LSP keymaps or diagnostics look | `lua/plugins/lsp.lua` |
| Change settings of one language server | `after/lsp/<server>.lua` |
| **Add a language** | new file in `lua/langs/` · [LSP & Languages](lsp-and-languages.md#adding-a-language) |
| Add a plugin | `lua/plugins/init.lua` + the module for when it's needed · [Plugins → Load order](plugins.md#load-order) |

**Read the code in this order**, since each file is short:

1. `init.lua`: 4 lines, the entry point.
2. `lua/core/options.lua` → `keymaps.lua`: plain Neovim settings.
3. `lua/plugins/init.lua`: every plugin, and *when* each one is loaded.
4. `lua/langs/typescript.lua`: what a language definition looks like.
5. `lua/plugins/lsp.lua`: how those definitions become running language servers.

**Try out changes without restarting**: after editing a file under `lua/core/`, run `:source %`.
Plugin modules are safest to test with a restart (`Ctrl+q`, then `nvim` again).

**Inspect live state** with `:lua =` (prints any Lua value):

```vim
:lua =require('langs')                       " merged language registry
:lua =vim.lsp.get_clients({ bufnr = 0 })[1].name
:lua =vim.tbl_keys(package.loaded)            " every loaded module
:verbose nmap <leader>ff                     " where a keymap was defined
:verbose set shiftwidth?                     " where an option was last set
```

---

## Next steps

- Skim [Keymaps](keymaps.md) once and pick 3 keys to practise this week.
- Run `:Tutor` if Vim motions (`w`, `b`, `ci"`, `dap`…) are new to you; this setup builds on them.
- Read [Plugins](plugins.md) to see what each plugin does and how it's configured.
