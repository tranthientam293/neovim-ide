vim.o.hlsearch = true
vim.o.incsearch = true
vim.wo.number = true
vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.wo.signcolumn = 'yes'
vim.o.backup = false
vim.o.writebackup = false
vim.o.completeopt = 'menuone,noselect'
vim.opt.termguicolors = true
vim.o.whichwrap = 'bs<>[]hl'
vim.o.wrap = false
vim.o.linebreak = true
vim.o.scrolloff = 4
vim.o.sidescrolloff = 8
vim.o.relativenumber = true
vim.o.numberwidth = 4
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.cursorline = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.smartindent = true
vim.o.showmode = true
vim.o.backspace = 'indent,eol,start'
vim.o.pumheight = 10
vim.o.conceallevel = 0
vim.o.fileencoding = 'utf-8'
vim.o.cmdheight = 1
vim.o.autoindent = true
vim.opt.shortmess:append('c')
vim.opt.iskeyword:append('-')
vim.opt.formatoptions:remove({ 'c', 'r', 'o' })
vim.opt.runtimepath:remove('usr/share/vim/vimfiles')

-- Blinking cursor
---@diagnostic disable-next-line: missing-fields
vim.opt.guicursor = {
  'n-v-c:block', -- Normal, visual, command-line: block cursor
  'i-ci-ve:ver25', -- Insert, command-line insert, visual-exclude: vertical bar cursor with 25% width
  'r-cr:hor20', -- Replace, command-line replace: horizontal bar cursor with 20% height
  'o:hor50', -- Operator-pending: horizontal bar cursor with 50% height
  'a:blinkwait700-blinkoff400-blinkon250', -- All modes: blinking settings
  'sm:block-blinkwait175-blinkoff150-blinkon175', -- Showmatch: block cursor with specific blinking settings
}

-- LSP / completion UI
vim.o.updatetime = 250 -- faster CursorHold (reference highlighting)
vim.o.winborder = 'rounded' -- borders on hover, signature help, diagnostics floats

-- Folding (treesitter-based, set per buffer in plugins/treesitter.lua); start with everything open
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
